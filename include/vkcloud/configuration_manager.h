#pragma once
#include <map>
#include <string>

struct SectionInfo {
  SectionInfo() {}
  ~SectionInfo() { section_datas_.clear(); }

  SectionInfo(const SectionInfo &src) { section_datas_ = src.section_datas_; }

  SectionInfo &operator=(const SectionInfo &src) {
    if (&src != this)
      this->section_datas_ = src.section_datas_;

    return *this;
  }

  std::string &operator[](const std::string &key) {
    return section_datas_[key];
  }

  std::string &GetValue(const std::string &key) { return (*this)[key]; }

  std::map<std::string, std::string> section_datas_;
};

class ConfigMgr {
public:
  ~ConfigMgr() = default;
  SectionInfo &operator[](const std::string &section) {
    return _config_map[section];
  }

  ConfigMgr &operator=(const ConfigMgr &src) {
    if (&src != this)
      this->_config_map = src._config_map;
    return *this;
  };

  ConfigMgr(const ConfigMgr &src) { this->_config_map = src._config_map; }

  static ConfigMgr &Instance() {
    static ConfigMgr cfg_mgr;
    return cfg_mgr;
  }

  std::string GetValue(const std::string &section, const std::string &key);

private:
  ConfigMgr();
  // 存储section和key-value对的map
  std::map<std::string, SectionInfo> _config_map;
};
