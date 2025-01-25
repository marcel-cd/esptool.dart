import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:esptool/src/models.dart';

abstract class TransportPlatform extends PlatformInterface {
  TransportPlatform() : super(token: _token);

  static final Object _token = Object();

  static late TransportPlatform _instance;

  /// The default instance of [PathProviderPlatform] to use.
  ///
  /// Defaults to [MethodChannelPathProvider].
  static TransportPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [PathProviderPlatform] when they register themselves.
  static set instance(TransportPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> init();

  Future<void> exit();

  Future<List<UsbDevice>> getDeviceList();

  Future<bool> connectDevice(UsbDevice usbDevice);
}
