#include "vkcloud/verify_grpc_client.h"

#include "vkcloud/configuration_manager.h"

VerifyGRPCClient::VerifyGRPCClient() {
  auto &gCfgMgr = ConfigMgr::Instance();
  std::string host = gCfgMgr["VarifyServer"]["Host"];
  std::string port = gCfgMgr["VarifyServer"]["Port"];
  pool_.reset(new RPConPool(5, host, port));
}
