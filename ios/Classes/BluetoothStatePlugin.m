#import "BluetoothStatePlugin.h"
@import AVFoundation;

@implementation BluetoothStatePlugin {
    FlutterEventSink _eventSink;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"bluetooth_state_plugin"
            binaryMessenger:[registrar messenger]];
  BluetoothStatePlugin* instance = [[BluetoothStatePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"bluetooth_state_stream_plugin" binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _eventSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)eventSink {
    _eventSink = eventSink;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(handleRouteChange:) name:AVAudioSessionRouteChangeNotification object:session];
    return nil;
}

- (void)handleRouteChange: (NSNotification *)notification {
    if (!_eventSink) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *reasonValueNumber = userInfo[AVAudioSessionRouteChangeReasonKey];
    AVAudioSessionRouteChangeReason reasonValue = [reasonValueNumber unsignedIntegerValue];
    switch (reasonValue) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            _eventSink([NSNumber numberWithBool:YES]);
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            _eventSink([NSNumber numberWithBool:NO]);
            break;
        default:
            break;
    }
}

@end
