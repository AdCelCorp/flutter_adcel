import 'dart:async';

import 'package:flutter/services.dart';
import 'adcel_interstitial_listener.dart';

class AdCel {
  static const MethodChannel _channel = const MethodChannel('flutter_adcel');

  static AdCelInterstitialListener interstitialListener;

  static Future<Null> init(final String key, final List<String> types) async {
    await _channel.invokeMethod('init', {'key': key, 'types': types});
  }

  static Future<Null> setInterstitialListener(AdCelInterstitialListener interstitialListener) async {
    AdCel.interstitialListener = interstitialListener;
    _channel.setMethodCallHandler(_handle);
  }

  static Future<Null> showInterstitialAd(String type) async {
    await _channel.invokeMethod('showInterstitialAd', {'type': type});
  }

  static Future<Null> showInterstitialAdZone(String type, String zone) async {
    await _channel.invokeMethod('showInterstitialAd',{'type':type, 'zone': zone});
  }

  static Future<Null> setLogging(bool on) async {
    await _channel.invokeMethod('setLogging',{'on':on});
  }

  static Future<Null> setTestMode(bool on) async {
    await _channel.invokeMethod('setTestMode',{'on':on});
  }

  static Future<Null> setUserConsent(bool on) async {
    await _channel.invokeMethod('setUserConsent', {'on': on});
  }

  static Future<Null> requestTrackingAuthorization() async {
    await _channel.invokeMethod('requestTrackingAuthorization');
  }

  static Future<dynamic> _handle(MethodCall methodCall) async {
    if (methodCall.method == 'onFirstInterstitialLoad')
      interstitialListener.onFirstInterstitialLoad(methodCall.arguments['type'], methodCall.arguments['provider']);
    else if (methodCall.method == 'onInterstitialWillAppear')
      interstitialListener.onInterstitialWillAppear(methodCall.arguments['type'], methodCall.arguments['provider']);
    else if (methodCall.method == 'onInterstitialClicked')
      interstitialListener.onInterstitialClicked(methodCall.arguments['type'], methodCall.arguments['provider']);
    else if (methodCall.method == 'onInterstitialDidDisappear')
      interstitialListener.onInterstitialDidDisappear(methodCall.arguments['type'], methodCall.arguments['provider']);
    else if (methodCall.method == 'onInterstitialFailLoad')
      interstitialListener.onInterstitialFailLoad(methodCall.arguments['type'], methodCall.arguments['provider']);
    else if (methodCall.method == 'onInterstitialFailedToShow')
      interstitialListener.onInterstitialFailedToShow(methodCall.arguments['type']);
    else if (methodCall.method == 'onRewardedCompleted')
      interstitialListener.onRewardedCompleted(
          methodCall.arguments['provider'],
          methodCall.arguments['currencyName'],
          methodCall.arguments['currencyValue']
      );
  }
}
