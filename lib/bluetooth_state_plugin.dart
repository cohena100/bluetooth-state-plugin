import 'dart:async';

import 'package:flutter/services.dart';

class BluetoothStatePlugin {
  static const MethodChannel _channel =
      const MethodChannel('bluetooth_state_plugin');
  static const EventChannel _eventChannel = const EventChannel('bluetooth_state_stream_plugin');
  static Stream<int> _intStream;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Stream<int> get intStream {
    if (_intStream == null) {
      _intStream = _eventChannel.receiveBroadcastStream().map<int>((value) => value);

    }
    return _intStream;
  }
}
