import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:esptool/src/models.dart';
import 'package:esptool/src/transport_platform_interface.dart';

const MethodChannel _channel = MethodChannel('esptool');

class TransportAndroid extends TransportPlatform {
  // For example/.dart_tool/flutter_build/generated_main.dart
  static registerWith() {
    TransportPlatform.instance = TransportAndroid();
  }

  @override
  Future<bool> init() async {
    return true;
  }

  @override
  Future<void> exit() async {
    return;
  }

  @override
  Future<List<UsbDevice>> getDeviceList() async {
    List<Map<dynamic, dynamic>> devices =
        (await _channel.invokeListMethod('getDeviceList'))!;
    return devices.map((device) => UsbDevice.fromMap(device)).toList();
  }

  @override
  Future<bool> connectDevice(UsbDevice usbDevice) async {
    return await _channel.invokeMethod('connectDevice', usbDevice.toMap());
  }
}
