#include "vkcloud/asio_io_service_pool.h"

AsioIOServicePool::AsioIOServicePool(std::size_t size) : io_services_(size) {
  for (auto &io_service : io_services_) {
    works_.emplace_back(io_service.get_executor());
    threads_.emplace_back([&io_service]() { io_service.run(); });
  }
}

AsioIOServicePool::~AsioIOServicePool() { Stop(); }

AsioIOServicePool::IOService &AsioIOServicePool::GetIOService() {
  auto &io_service = io_services_[io_service_idx_++];
  if (io_service_idx_ == io_services_.size())
    io_service_idx_ = 0;

  return io_service;
}

void AsioIOServicePool::Stop() {
  for (auto &work : works_)
    work.reset();

  for (auto &thread : threads_)
    thread.join();
}
