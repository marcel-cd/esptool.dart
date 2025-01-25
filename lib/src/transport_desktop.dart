import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter/foundation.dart';
import 'package:libusb_new/libusb_new.dart';
import 'package:esptool/src/models.dart';

import 'transport_platform_interface.dart';
import 'utils.dart';

late Libusb _libusb;

class TransportWindows extends _TransportDesktop {
  // For example/.dart_tool/flutter_build/generated_main.dart
  static registerWith() {
    TransportPlatform.instance = TransportMacos();
    _libusb = Libusb(DynamicLibrary.open('libusb-1.0.23.dll'));
  }
}

class TransportMacos extends _TransportDesktop {
  // For example/.dart_tool/flutter_build/generated_main.dart
  static registerWith() {
    TransportPlatform.instance = TransportMacos();
    _libusb = Libusb(DynamicLibrary.open('libusb-1.0.23.dylib'));
  }
}

class TransportLinux extends _TransportDesktop {
  // For example/.dart_tool/flutter_build/generated_main.dart
  static registerWith() {
    TransportPlatform.instance = TransportLinux();
    _libusb = Libusb(
      DynamicLibrary.open(
        '${File(Platform.resolvedExecutable).parent.path}/lib/libusb-1.0.so',
      ),
    );
  }
}

class _TransportDesktop extends TransportPlatform {
  Pointer<libusb_device_handle>? _devHandle;

  @override
  Future<bool> init() async {
    return _libusb.libusb_init(nullptr) == libusb_error.LIBUSB_SUCCESS;
  }

  @override
  Future<void> exit() async {
    return _libusb.libusb_exit(nullptr);
  }

  @override
  Future<List<UsbDevice>> getDeviceList() {
    var deviceListPtr = ffi.calloc<Pointer<Pointer<libusb_device>>>();
    try {
      var count = _libusb.libusb_get_device_list(nullptr, deviceListPtr);
      if (count < 0) {
        return Future.value([]);
      }
      try {
        return Future.value(_iterateDevice(deviceListPtr.value).toList());
      } finally {
        _libusb.libusb_free_device_list(deviceListPtr.value, 1);
      }
    } finally {
      ffi.calloc.free(deviceListPtr);
    }
  }

  Iterable<UsbDevice> _iterateDevice(
    Pointer<Pointer<libusb_device>> deviceList,
  ) sync* {
    var descPtr = ffi.calloc<libusb_device_descriptor>();

    for (var i = 0; deviceList[i] != nullptr; i++) {
      var dev = deviceList[i];
      var addr = _libusb.libusb_get_device_address(dev);
      var getDesc =
          _libusb.libusb_get_device_descriptor(dev, descPtr) ==
          libusb_error.LIBUSB_SUCCESS;

      if (getDesc &&
          (descPtr.ref.idVendor == 0x303a || descPtr.ref.idVendor == 0x1a86)) {
        yield UsbDevice(
          identifier: addr.toString(),
          vendorId: getDesc ? descPtr.ref.idVendor : 0,
          productId: getDesc ? descPtr.ref.idProduct : 0,
          configurationCount: getDesc ? descPtr.ref.bNumConfigurations : 0,
        );
      }
    }

    ffi.calloc.free(descPtr);
  }

  @override
  Future<bool> connectDevice(UsbDevice usbDevice) async {
    return true;
  }
}
