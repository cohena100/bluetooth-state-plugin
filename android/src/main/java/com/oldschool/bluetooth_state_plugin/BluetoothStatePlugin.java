package com.oldschool.bluetooth_state_plugin;

import android.bluetooth.BluetoothHeadset;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * BluetoothStatePlugin
 */
public class BluetoothStatePlugin implements MethodCallHandler, EventChannel.StreamHandler {

    private Registrar mRegistrar;
    private EventChannel.EventSink mEventSink;
    public AudioChangeBroadcastReceiver mMyReceiver;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        BluetoothStatePlugin plugin = new BluetoothStatePlugin(registrar);
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "bluetooth_state_plugin");
        channel.setMethodCallHandler(plugin);
        final EventChannel eventChannel = new EventChannel(registrar.messenger(), "bluetooth_state_stream_plugin");
        eventChannel.setStreamHandler(plugin);
    }

    BluetoothStatePlugin(Registrar registrar) {
        mRegistrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onListen(java.lang.Object o, EventChannel.EventSink eventSink) {
        mEventSink = eventSink;
        mMyReceiver = new AudioChangeBroadcastReceiver(mEventSink);
        IntentFilter i = new IntentFilter(BluetoothHeadset.ACTION_CONNECTION_STATE_CHANGED);
        mRegistrar.activeContext().registerReceiver(mMyReceiver, i);
    }

    @Override
    public void onCancel(java.lang.Object o) {
        mEventSink = null;
        mRegistrar.activeContext().unregisterReceiver(mMyReceiver);
    }
}

class AudioChangeBroadcastReceiver extends BroadcastReceiver {

    private EventChannel.EventSink mEventSink;

    AudioChangeBroadcastReceiver(EventChannel.EventSink eventSink) {
        mEventSink = eventSink;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals(BluetoothHeadset.ACTION_CONNECTION_STATE_CHANGED)) {
            int state = intent.getIntExtra(BluetoothHeadset.EXTRA_STATE, -1);
            switch (state) {
                case BluetoothHeadset.STATE_CONNECTED:
                    mEventSink.success(new Boolean(true));
                    break;
                case BluetoothHeadset.STATE_DISCONNECTED:
                    mEventSink.success(new Boolean(false));
                    break;
            }
        }
    }
}