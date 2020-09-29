import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'adcel_banner_listener.dart';
import 'adcel_banner_controller.dart';

class AdCelBanner extends StatefulWidget {
  static const String SIZE_320x50 = "320x50";
  static const String SIZE_300x50 = "320x50";
  static const String SIZE_300x250 = "320x50";
  static const String SIZE_728x90 = "728x90";

  final String adSize;
  final AdCelBannerListener listener;
  final void Function(AdCelBannerController) onBannerCreated;

  AdCelBanner({
    Key key,
    @required this.adSize,
    this.listener,
    this.onBannerCreated
  }) : super(key: key);

  @override
  _AdCelBannerState createState() => _AdCelBannerState();
}

class _AdCelBannerState extends State<AdCelBanner> {
  final UniqueKey _key = UniqueKey();
  AdCelBannerController _controller;
  String adSize;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return SizedBox.fromSize(
        size: Size(320, 50),
        child: AndroidView(
          key: _key,
          viewType: 'flutter_adcel/banner',
          creationParams: bannerCreationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: _onPlatformViewCreated,
        )
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return SizedBox.fromSize(
        size: Size(320, 50),
        child: UiKitView(
          key: _key,
          viewType: 'flutter_adcel/banner',
          creationParams: bannerCreationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: _onPlatformViewCreated,
        )
      );
    }

    return Text('$defaultTargetPlatform is not yet supported by the plugin');
  }

  void _onPlatformViewCreated(int id) {
    _controller = AdCelBannerController(id, widget.listener);

    if (widget.onBannerCreated != null) {
      widget.onBannerCreated(_controller);
    }
  }

  Map<String, dynamic> get bannerCreationParams => <String, dynamic>{
    'adSize': widget.adSize.toString(),
  };
}