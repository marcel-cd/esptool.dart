#ifndef FLUTTER_PLUGIN_ESPTOOL_PLUGIN_H_
#define FLUTTER_PLUGIN_ESPTOOL_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace esptool {

class EsptoolPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  EsptoolPlugin();

  virtual ~EsptoolPlugin();

  // Disallow copy and assign.
  EsptoolPlugin(const EsptoolPlugin&) = delete;
  EsptoolPlugin& operator=(const EsptoolPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace esptool

#endif  // FLUTTER_PLUGIN_ESPTOOL_PLUGIN_H_
