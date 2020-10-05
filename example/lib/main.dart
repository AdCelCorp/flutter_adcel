import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_adcel/flutter_adcel.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with AdCelInterstitialListener, AdCelBannerListener {
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    initAdCel();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initAdCel() async {
    String key = '';
    if(Platform.isAndroid){
      key = '89fdf849-b5bc-49d0-ad51-0b790e777ae4:fc7094bb-3ca7-4450-9a7e-320b6b4f4e42';
    } else if(Platform.isIOS){
      key = 'ab3d155f-7703-4289-8372-848737c2b879:d949782d-cb74-4501-8f38-613f89a579b9';
    }
    AdCel.setInterstitialListener(this);
    AdCel.setLogging(true);
    //AdCel.setTestMode(true);
    AdCel.init(key, [
      AdCelAdType.BANNER,
      AdCelAdType.IMAGE,
      AdCelAdType.VIDEO,
      AdCelAdType.INTERSTITIAL,
      AdCelAdType.REWARDED
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            MaterialButton(
              child: Text('show ad'),
              onPressed: _isButtonDisabled ? null : () {
                AdCel.showInterstitialAd(AdCelAdType.VIDEO);
              },

            ),
            AdCelBanner(
              adSize: AdCelBanner.SIZE_320x50,
              listener: this,
              onBannerCreated: (AdCelBannerController controller) {
                //controller.setRefreshInterval(25);
                //controller.loadNextAd();
              },
            )
          ],
        )
      ),
    );
  }

  @override
  void onFirstInterstitialLoad(String adType, String provider) {
    print('onFirstInterstitialLoad: $adType, $provider');
    setState(() {
      _isButtonDisabled = false;
    });
  }

  @override
  void onInterstitialClicked(String adType, String provider) {
    print('onInterstitialClicked: $adType, $provider');
  }

  @override
  void onInterstitialClosed(String adType, String provider) {
    print('onInterstitialClosed: $adType, $provider');
  }

  @override
  void onInterstitialFailLoad(String adType, String error) {
    print('onInterstitialFailLoad: $adType, $error');
  }

  @override
  void onInterstitialFailedToShow(String adType) {
    print('onInterstitialFailedToShow: $adType');
  }

  @override
  void onInterstitialStarted(String adType, String provider) {
    print('onInterstitialStarted: $adType, $provider');
  }

  @override
  void onRewardedCompleted(String adProvider, String currencyName, String currencyValue) {
    print('onRewardedCompleted: $adProvider, $currencyName, $currencyValue');
  }

  @override
  void onBannerClicked() {
    print('onBannerClicked');
  }

  @override
  void onBannerFailedToLoad() {
    print('onBannerFailedToLoad');
  }

  @override
  void onBannerFailedToLoadProvider(String provider) {
    print('onBannerFailedToLoadProvider: $provider');
  }

  @override
  void onBannerLoad() {
    print('onBannerLoad');
  }
}
