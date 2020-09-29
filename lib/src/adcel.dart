import 'dart:async';

import 'package:flutter/services.dart';
import 'adcel_interstitial_listener.dart';

class AdCel {
  static const MethodChannel _channel =
  const MethodChannel('flutter_adcel');

  static AdCelInterstitialListener interstitialListener;

  static Future<Null> init(final String key,final List<String> types) async {
    await _channel.invokeMethod('init',{'key':key,'types':types});
  }

  static Future<Null> setInterstitialListener(AdCelInterstitialListener interstitialListener) async {
    AdCel.interstitialListener = interstitialListener;
    _channel.setMethodCallHandler(_handle);
  }

  static Future<Null> showInterstitialAd(String type) async {
    await _channel.invokeMethod('showInterstitialAd',{'type':type});
  }

  static Future<dynamic> _handle(MethodCall methodCall) async {
    if(methodCall.method == 'onFirstInterstitialLoad')
      interstitialListener.onFirstInterstitialLoad(methodCall.arguments['type'],
          methodCall.arguments['provider']);
    else if(methodCall.method == 'onInterstitialStarted')
      interstitialListener.onInterstitialStarted(methodCall.arguments['type'],
          methodCall.arguments['provider']);
    else if(methodCall.method == 'onInterstitialClicked')
      interstitialListener.onInterstitialClicked(methodCall.arguments['type'],
          methodCall.arguments['provider']);
    else if(methodCall.method == 'onInterstitialClosed')
      interstitialListener.onInterstitialClosed(methodCall.arguments['type'],
          methodCall.arguments['provider']);
    else if(methodCall.method == 'onInterstitialFailLoad')
      interstitialListener.onInterstitialFailLoad(methodCall.arguments['type'],
          methodCall.arguments['provider']);
    else if(methodCall.method == 'onInterstitialFailedToShow')
      interstitialListener.onInterstitialFailedToShow(methodCall.arguments['type']);
    else if(methodCall.method == 'onRewardedCompleted')
      interstitialListener.onRewardedCompleted(methodCall.arguments['provider'],
          methodCall.arguments['currencyName'], methodCall.arguments['currencyValue']);
  }
}