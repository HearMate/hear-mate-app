//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audioplayers_windows/audioplayers_windows_plugin.h>
#include <serious_python_windows/serious_python_windows_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AudioplayersWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AudioplayersWindowsPlugin"));
  SeriousPythonWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SeriousPythonWindowsPluginCApi"));
}
