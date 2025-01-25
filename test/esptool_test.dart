import 'package:flutter_test/flutter_test.dart';
import 'package:esptool/esptool.dart';
import 'package:esptool/esptool_platform_interface.dart';
import 'package:esptool/esptool_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEsptoolPlatform
    with MockPlatformInterfaceMixin
    implements EsptoolPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final EsptoolPlatform initialPlatform = EsptoolPlatform.instance;

  test('$MethodChannelEsptool is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEsptool>());
  });

  test('getPlatformVersion', () async {
    Esptool esptoolPlugin = Esptool();
    MockEsptoolPlatform fakePlatform = MockEsptoolPlatform();
    EsptoolPlatform.instance = fakePlatform;

    expect(await esptoolPlugin.getPlatformVersion(), '42');
  });
}
