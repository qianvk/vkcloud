#include "vkcloud/server.h"

int main(int argc, char *argv[]) {
  try {
    auto port = static_cast<unsigned short>(8088);
    asio::io_context ioc{1};
    asio::signal_set signals{ioc, SIGINT, SIGTERM};
    signals.async_wait(
        [&ioc](const boost::system::error_code &ec, int signal_number) {
          if (ec)
            return;

          ioc.stop();
        });

    std::make_shared<Server>(ioc, port)->Start();
    ioc.run();
  } catch (const std::exception &e) {
    return EXIT_FAILURE;
  }
}
