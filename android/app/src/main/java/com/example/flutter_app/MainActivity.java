package com.example.flutter_app;

import android.os.Bundle;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "flutter-app.com/battery";
  private int getBatteryLevel(){
    int batteryLevel = -1;
    if(VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP){
      BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    }
    else{
      Intent intent = new ContextWrapper(getApplicationContext())
      .registerReceiver(null,new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL,-1) * 100) /
       intent.getIntExtra(BatteryManager.EXTRA_SCALE,-1);
    }
    return batteryLevel;
  }
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    new MethodChannel(getFlutterView(),CHANNEL)
      .setMethodCallHandler(new MethodCallHandler(){
        @Override 
        public void onMethodCall(MethodCall call, Result result){
          if(call.method.equals("getBatteryLevel")){
            int batteryLevel = getBatteryLevel();
            if(batteryLevel != -1){
              result.success(batteryLevel);
            }
            else{
              result.error("UNAVAILABE","Could not get battery lavel",null);
            }
          }
          else{
            result.notImplemented();
          }
        }
      });
    GeneratedPluginRegistrant.registerWith(this);
  }
}
