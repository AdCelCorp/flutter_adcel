import 'package:flutter/services.dart';
import 'package:flutter_adcel/src/adcel_banner_listener.dart';

class AdCelBannerController {
  final MethodChannel _channel;
  AdCelBannerListener listener;

  AdCelBannerController(int id, this.listener)
      : _channel = MethodChannel('flutter_adcel/banner_$id') {
    if (listener != null) {
      _channel.setMethodCallHandler(_handle);
      _channel.invokeMethod('setListener');
    }
  }

  void dispose() {
    _channel.invokeMethod('dispose');
  }

  Future<dynamic> _handle(MethodCall methodCall) async {
    if(methodCall.method == 'onBannerLoad')
      listener.onBannerLoad();
    else if(methodCall.method == 'onBannerFailedToLoadProvider')
      listener.onBannerFailedToLoadProvider(methodCall.arguments['provider']);
    else if(methodCall.method == 'onBannerFailedToLoad')
      listener.onBannerFailedToLoad();
    else if(methodCall.method == 'onBannerClicked')
      listener.onBannerClicked();
  }
}