#include "vkcloud/const.h"
#include "vkcloud/singleton.h"
#include <vector>

class AsioIOServicePool : public Singleton<AsioIOServicePool> {
  friend class Singleton<AsioIOServicePool>;

public:
  using IOService = asio::io_context;
  using Work = asio::executor_work_guard<asio::io_context::executor_type>;

  ~AsioIOServicePool();

  IOService &GetIOService();
  void Stop();

private:
  AsioIOServicePool(
      std::size_t size = 2 /* std::thread::hardware_concurrency() */);
  std::vector<IOService> io_services_;
  std::vector<Work> works_;
  std::vector<std::thread> threads_;
  std::size_t io_service_idx_{0};
};
