#include "vkcloud/server.h"

#include "vkcloud/asio_io_service_pool.h"
#include "vkcloud/http_connection.h"

Server::Server(asio::io_context &ioc, unsigned port)
    : acceptor_(ioc, tcp::endpoint(tcp::v4(), port)), ioc_(ioc) {}

void Server::Start() {
  auto self = shared_from_this();
  auto &io_service = AsioIOServicePool::Instance()->GetIOService();
  auto conn_ptr = std::make_shared<HttpConnection>(io_service);
  acceptor_.async_accept(conn_ptr->GetSocket(),
                         [self, conn_ptr](beast::error_code ec) {
                           try {
                             if (ec) {
                               self->Start();
                               return;
                             }

                             conn_ptr->Start();
                             self->Start();
                           } catch (const std::exception &e) {
                             self->Start();
                           }
                         });
}
