#include <grpcpp/grpcpp.h>

#include "vkcloud/const.h"
#include "vkcloud/message.grpc.pb.h"
#include "vkcloud/singleton.h"

class VerifyGRPCClient : public Singleton<VerifyGRPCClient> {
  friend class Singleton<VerifyGRPCClient>;

public:
  message::GetVerifyRsp GetVarifyCode(std::string email) {
    grpc::ClientContext context;
    message::GetVerifyRsp reply;
    message::GetVerifyReq request;
    request.set_email(email);

    grpc::Status status = stub_->GetVerifyCode(&context, request, &reply);

    if (status.ok()) {

      return reply;
    } else {
      reply.set_error(static_cast<int32_t>(ErrorCode::kRPCFailed));
      return reply;
    }
  }

private:
  VerifyGRPCClient() {
    std::shared_ptr<grpc::Channel> channel = grpc::CreateChannel(
        "127.0.0.1:50051", grpc::InsecureChannelCredentials());
    stub_ = message::VerifyService::NewStub(channel);
  }

  std::unique_ptr<message::VerifyService::Stub> stub_;
};
