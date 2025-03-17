#pragma once
#include <memory>

#include "vkcloud/const.h"

class Server : public std::enable_shared_from_this<Server> {
public:
  Server(asio::io_context &ioc, unsigned port);
  void Start();

private:
  tcp::acceptor acceptor_;
  asio::io_context &ioc_;
};
