#include "vkcloud/configuration_manager.h"

#include <filesystem>
#include <iostream>

#include "json/json.h"
#include <fstream>

ConfigMgr::ConfigMgr() {
  std::filesystem::path config_path =
      std::filesystem::current_path() / "config.json";
  try {
    if (!std::filesystem::exists(config_path))
      return;

    // Open the file in binary mode and position the cursor at the end
    std::ifstream file(config_path, std::ios::binary | std::ios::ate);
    if (!file) {
      throw std::runtime_error("Could not open file: " + config_path.string());
    }

    // Get the size of the file
    std::streamsize fileSize = file.tellg();
    if (fileSize == -1) {
      throw std::runtime_error("Failed to determine file size: " +
                               config_path.string());
    }

    // Create a string to hold the file contents
    std::string fileContent(fileSize, '\0');

    // Return to the beginning of the file and read its contents
    file.seekg(0);
    if (!file.read(fileContent.data(), fileSize)) {
      throw std::runtime_error("Error reading file: " + config_path.string());
    }

    Json::Value root;
    Json::CharReaderBuilder builder;
    const std::unique_ptr<Json::CharReader> reader(builder.newCharReader());
    JSONCPP_STRING err;
    if (!reader->parse(fileContent.c_str(),
                       fileContent.c_str() + fileContent.size(), &root, &err)) {
      throw std::runtime_error("Error parse config file");
    }

    auto member_names = root.getMemberNames();
    for (const auto &member_name : member_names) {
      auto iter = _config_map.emplace(member_name, SectionInfo{}).first;
      const auto &member_json = root[member_name];
      auto child_member_names = member_json.getMemberNames();
      for (const auto &child_member_name : child_member_names) {
        iter->second[child_member_name] =
            member_json[child_member_name].asString();
      }
    }

  } catch (const std::filesystem::filesystem_error &e) {
    std::cout << e.what() << "\n";
  } catch (const std::exception &e) {
    std::cout << e.what() << "\n";
  }
}

std::string ConfigMgr::GetValue(const std::string &section,
                                const std::string &key) {
  if (_config_map.find(section) == _config_map.end()) {
    return "";
  }

  return _config_map[section].GetValue(key);
}
