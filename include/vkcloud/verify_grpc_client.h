#include <queue>

#include "grpcpp/grpcpp.h"

#include "vkcloud/const.h"
#include "vkcloud/message.grpc.pb.h"
#include "vkcloud/singleton.h"

class RPConPool {
public:
  RPConPool(size_t poolSize, std::string host, std::string port)
      : poolSize_(poolSize), host_(std::move(host)), port_(std::move(port)),
        b_stop_(false) {
    for (size_t i = 0; i < poolSize_; ++i) {

      std::shared_ptr<grpc::Channel> channel = grpc::CreateChannel(
          host + ":" + port, grpc::InsecureChannelCredentials());

      connections_.push(message::VerifyService::NewStub(channel));
    }
  }

  ~RPConPool() {
    std::lock_guard<std::mutex> lock(mutex_);
    Close();
    while (!connections_.empty()) {
      connections_.pop();
    }
  }

  std::unique_ptr<message::VerifyService::Stub> getConnection() {
    std::unique_lock<std::mutex> lock(mutex_);
    cond_.wait(lock, [this] {
      if (b_stop_) {
        return true;
      }
      return !connections_.empty();
    });
    // 如果停止则直接返回空指针
    if (b_stop_) {
      return nullptr;
    }
    auto context = std::move(connections_.front());
    connections_.pop();
    return context;
  }

  void returnConnection(std::unique_ptr<message::VerifyService::Stub> context) {
    std::lock_guard<std::mutex> lock(mutex_);
    if (b_stop_) {
      return;
    }
    connections_.push(std::move(context));
    cond_.notify_one();
  }

  void Close() {
    b_stop_ = true;
    cond_.notify_all();
  }

private:
  std::atomic<bool> b_stop_;
  size_t poolSize_;
  std::string host_;
  std::string port_;
  std::queue<std::unique_ptr<message::VerifyService::Stub>> connections_;
  std::mutex mutex_;
  std::condition_variable cond_;
};

class VerifyGRPCClient : public Singleton<VerifyGRPCClient> {
  friend class Singleton<VerifyGRPCClient>;

public:
  message::GetVerifyRsp GetVerifyCode(std::string email) {
    grpc::ClientContext context;
    message::GetVerifyRsp reply;
    message::GetVerifyReq request;
    request.set_email(email);

    auto stub = pool_->getConnection();
    grpc::Status status = stub->GetVerifyCode(&context, request, &reply);

    if (status.ok())
      pool_->returnConnection(std::move(stub));
    else
      reply.set_error(static_cast<int32_t>(ErrorCode::kRPCFailed));

    return reply;
  }

private:
  VerifyGRPCClient();

  std::unique_ptr<RPConPool> pool_;
};
