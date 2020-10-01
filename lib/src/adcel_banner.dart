import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'adcel_banner_listener.dart';
import 'adcel_banner_controller.dart';

class AdCelBanner extends StatefulWidget {
  static const String SIZE_320x50 = "320x50";
  static const String SIZE_300x50 = "300x50";
  static const String SIZE_300x250 = "300x250";
  static const String SIZE_728x90 = "728x90";

  final String adSize;
  final AdCelBannerListener listener;
  final void Function(AdCelBannerController) onBannerCreated;

  const AdCelBanner({
    Key key,
    @required this.adSize,
    this.listener,
    this.onBannerCreated
  }) : super(key: key);

  @override
  _AdCelBannerState createState() => _AdCelBannerState();
}

class _AdCelBannerState extends State<AdCelBanner> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        key: UniqueKey(),
        viewType: 'flutter_adcel/banner',
        creationParams: bannerCreationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        key: UniqueKey(),
        viewType: 'flutter_adcel/banner',
        creationParams: bannerCreationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }

    return Text('$defaultTargetPlatform is not yet supported by the plugin');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onBannerCreated == null) {
      return;
    }

    widget.onBannerCreated(AdCelBannerController(id, widget.listener));
  }

  Map<String, dynamic> get bannerCreationParams => <String, dynamic>{
    'adSize': widget.adSize.toString(),
  };
}