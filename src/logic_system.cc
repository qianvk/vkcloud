#include "vkcloud/logic_system.h"

#include <json/json.h>

#include "vkcloud/const.h"
#include "vkcloud/http_connection.h"
#include "vkcloud/verify_grpc_client.h"

LogicSystem::LogicSystem() {
  RegisterGet("/user", [](std::shared_ptr<HttpConnection> conn_ptr) {
    beast::ostream(conn_ptr->response_.body()) << "There is no any user!";
  });

  RegisterPost("/api/register", [](std::shared_ptr<HttpConnection> conn_ptr) {
    auto body_str = beast::buffers_to_string(
        conn_ptr->request_.body()
            .data()); // TODO(qianvk):
                      // multi_buffer是否是连续容器？是的话能否在后续的reader—>parse()中直接使用它的cstring
    conn_ptr->response_.set(http::field::content_type, "text/json");
    Json::Value req_root, resp_root;
    Json::CharReaderBuilder builder;
    const std::unique_ptr<Json::CharReader> reader(builder.newCharReader());
    JSONCPP_STRING err;
    if (!reader->parse(body_str.c_str(), body_str.c_str() + body_str.size(),
                       &req_root, &err)) {

      resp_root["error"] = static_cast<int>(ErrorCode::kErrorJson);
      beast::ostream(conn_ptr->response_.body())
          << resp_root.toStyledString(); // TODO(qianvk): use toCompactString();
      return;
    }

    auto email = req_root["email"].asString();
    message::GetVerifyRsp rsp =
        VerifyGRPCClient::Instance()->GetVarifyCode(email);
    resp_root["error"] = rsp.error();
    resp_root["code"] = rsp.code();
    resp_root["email"] = req_root["email"];
    beast::ostream(conn_ptr->response_.body()) << resp_root.toStyledString();
  });
}

void LogicSystem::RegisterGet(std::string path, HttpHandler handler) {
  get_handlers_.emplace(std::move(path), std::move(handler));
}

void LogicSystem::RegisterPost(std::string path, HttpHandler handler) {
  post_handlers_.emplace(std::move(path), std::move(handler));
}

bool LogicSystem::HandleGet(const std::string &path,
                            std::shared_ptr<HttpConnection> conn_ptr) {
  auto iter = get_handlers_.find(path);
  if (iter == get_handlers_.end())
    return false;

  iter->second(conn_ptr);
  return true;
}

bool LogicSystem::HandlePost(const std::string &path,
                             std::shared_ptr<HttpConnection> conn_ptr) {
  auto iter = post_handlers_.find(path);
  if (iter == post_handlers_.end())
    return false;

  iter->second(conn_ptr);
  return true;
}
