//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <esptool/esptool_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) esptool_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "EsptoolPlugin");
  esptool_plugin_register_with_registrar(esptool_registrar);
}
