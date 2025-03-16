#include "vkcloud/server.h"

#include "vkcloud/http_connection.h"

Server::Server(asio::io_context &ioc, unsigned port)
    : acceptor_(ioc, tcp::endpoint(tcp::v4(), port)), ioc_(ioc), socket_(ioc) {}

void Server::Start() {
  auto self = shared_from_this();
  acceptor_.async_accept(socket_, [self](beast::error_code ec) {
    try {
      if (ec) {
        self->Start();
        return;
      }

      std::make_shared<HttpConnection>(std::move(self->socket_))->Start();
      self->Start();
    } catch (const std::exception &e) {
      self->Start();
    }
  });
}
