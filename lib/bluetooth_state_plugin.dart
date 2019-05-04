import 'dart:async';

import 'package:flutter/services.dart';

class BluetoothStatePlugin {
  static const MethodChannel _channel =
      const MethodChannel('bluetooth_state_plugin');
  static const EventChannel _eventChannel = const EventChannel('bluetooth_state_stream_plugin');
  static Stream<bool> _bluetoothStream;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Stream<bool> get bluetoothStream {
    if (_bluetoothStream == null) {
      _bluetoothStream = _eventChannel.receiveBroadcastStream().map<bool>((value) => value);

    }
    return _bluetoothStream;
  }
}
