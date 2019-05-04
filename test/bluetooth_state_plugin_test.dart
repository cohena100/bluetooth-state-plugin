import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bluetooth_state_plugin/bluetooth_state_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('bluetooth_state_plugin');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await BluetoothStatePlugin.platformVersion, '42');
  });
}
