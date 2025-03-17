#pragma once

#include <memory>

#include "vkcloud/const.h"

class HttpConnection : public std::enable_shared_from_this<HttpConnection> {
  friend class LogicSystem;

public:
  HttpConnection(asio::io_context &ioc);
  void Start();
  tcp::socket &GetSocket() { return socket_; }

private:
  void HandleRequest();
  void WriteResponse();
  void CheckDeadLine();

  tcp::socket socket_;
  beast::flat_buffer buffer_{8192};
  http::request<http::dynamic_body> request_;
  http::response<http::dynamic_body> response_;
  asio::steady_timer deadline_{socket_.get_executor(),
                               std::chrono::seconds(60)};
};
