#include "vkcloud/http_connection.h"

#include "vkcloud/logic_system.h"
#include <iostream>

HttpConnection::HttpConnection(tcp::socket socket)
    : socket_(std::move(socket)) {}

void HttpConnection::Start() {
  auto self = shared_from_this();
  http::async_read(socket_, buffer_, request_,
                   [self](beast::error_code ec, std::size_t bytes_transfered) {
                     try {
                       std::cout << ec << "\n";
                       if (ec)
                         return;

                       boost::ignore_unused(bytes_transfered);
                       self->HandleRequest();
                       self->CheckDeadLine();
                     } catch (const std::exception &e) {
                     }
                   });
}

void HttpConnection::HandleRequest() {
  response_.version(request_.version());
  response_.keep_alive(false);
  std::cout << request_.version() << "\n";
  if (request_.method() == http::verb::get) {
    bool success = LogicSystem::Instance()->HandleGet(request_.target(),
                                                      shared_from_this());
    if (!success) {
      response_.result(http::status::not_found);
      response_.set(http::field::content_type, "text/plain");
      beast::ostream(response_.body()) << "Url not found";
      WriteResponse();
      return;
    }

    response_.result(http::status::ok);
    response_.set(http::field::server, "VKCloud/1.0");
    WriteResponse();
  } else if (request_.method() == http::verb::post) {
    bool success = LogicSystem::Instance()->HandlePost(request_.target(),
                                                       shared_from_this());
    if (!success) {
      response_.result(http::status::not_found);
      response_.set(http::field::content_type, "text/plain");
      beast::ostream(response_.body()) << "url not found\r\n";
      WriteResponse();
      return;
    }

    response_.result(http::status::ok);
    response_.set(http::field::server, "VKCloud/1.0");
    WriteResponse();
  }
}

void HttpConnection::CheckDeadLine() {
  auto self = shared_from_this();
  deadline_.async_wait([self](beast::error_code ec) {
    if (!ec)
      self->socket_.close();
  });
}

void HttpConnection::WriteResponse() {
  auto self = shared_from_this();
  response_.content_length(response_.body().size());
  http::async_write(socket_, response_,
                    [self](beast::error_code ec, std::size_t) {
                      self->socket_.shutdown(tcp::socket::shutdown_send, ec);
                      self->deadline_.cancel();
                    });
}
