#include "include/esptool/esptool_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "esptool_plugin.h"

void EsptoolPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  esptool::EsptoolPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
