import 'dart:async';

import 'package:flutter/services.dart';

class FlutterAdcel {
  static const MethodChannel _channel =
      const MethodChannel('flutter_adcel');

  static Future<Null> init(final String key,final List<String> types) async {
    await _channel.invokeMethod('init',{'key':key,'types':types});
  }

  static Future<Null> showInterstitialAd(String type) async {
    await _channel.invokeMethod('showInterstitialAd',{'type':type});
  }
}
