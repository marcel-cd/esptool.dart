import 'dart:typed_data';

import 'models.dart';
import 'transport_platform_interface.dart';

TransportPlatform get _platform => TransportPlatform.instance;

class Transport {
  static Future<bool> init() => _platform.init();

  static Future<void> exit() => _platform.exit();

  static Future<List<UsbDevice>> getDeviceList() => _platform.getDeviceList();

  static Future<bool> connectDevice(UsbDevice usbDevice) =>
      _platform.connectDevice(usbDevice);
}
