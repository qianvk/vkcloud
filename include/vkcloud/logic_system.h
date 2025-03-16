#pragma once

#include "vkcloud/singleton.h"
#include <functional>
#include <map>
#include <string>

class HttpConnection;
using HttpHandler = std::function<void(std::shared_ptr<HttpConnection>)>;

class LogicSystem : public Singleton<LogicSystem> {
  friend class Singleton<LogicSystem>;

public:
  ~LogicSystem() = default;
  bool HandleGet(const std::string &path,
                 std::shared_ptr<HttpConnection> conn_ptr);
  bool HandlePost(const std::string &path,
                  std::shared_ptr<HttpConnection> conn_ptr);

private:
  LogicSystem();
  void RegisterGet(std::string path, HttpHandler handler);
  void RegisterPost(std::string path, HttpHandler handler);
  std::map<std::string, HttpHandler> get_handlers_;
  std::map<std::string, HttpHandler> post_handlers_;
};
