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
    if (Platform.isAndroid) {
      key = '89fdf849-b5bc-49d0-ad51-0b790e777ae4:fc7094bb-3ca7-4450-9a7e-320b6b4f4e42';
    } else if (Platform.isIOS) {
      key = 'ab3d155f-7703-4289-8372-848737c2b879:d949782d-cb74-4501-8f38-613f89a579b9';
    }
    AdCel.setInterstitialListener(this);
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
                onPressed: _isButtonDisabled
                    ? null
                    : () {
                        AdCel.showInterstitialAd(AdCelAdType.VIDEO);
                      },
              ),
              Container(
                height: 50,
                color: Colors.blue[700],
                child: AdCelBanner(
                  adSize: AdCelBanner.SIZE_320x50,
                  listener: this,
                  onBannerCreated: (AdCelBannerController controller) {
                    print('MAIN.DART >>>> Load Banner Ad with ID = ${controller.getId}');
                  },
                ),
              ),
              Container(
                height: 250,
                color: Colors.green[700],
                child: AdCelBanner(
                  adSize: AdCelBanner.SIZE_300x250,
                  listener: this,
                  onBannerCreated: (AdCelBannerController controller) {
                    print('MAIN.DART >>>> Load Banner Ad with ID = ${controller.getId}');
                  },
                ),
              ),
            ],
          )),
    );
  }

  @override
  void onFirstInterstitialLoad(String adType, String provider) {
    print('MAIN.DART >>>> onFirstInterstitialLoad: $adType, $provider');
    setState(() {
      _isButtonDisabled = false;
    });
  }

  @override
  void onInterstitialClicked(String adType, String provider) {
    print('MAIN.DART >>>> onInterstitialClicked: $adType, $provider');
  }

  @override
  void onInterstitialDidDisappear(String adType, String provider) {
    print('MAIN.DART >>>> onInterstitialDidDisappear: $adType, $provider');
  }

  @override
  void onInterstitialFailLoad(String adType, String error) {
    print('MAIN.DART >>>> onInterstitialFailLoad: $adType, $error');
  }

  @override
  void onInterstitialFailedToShow(String adType) {
    print('MAIN.DART >>>> onInterstitialFailedToShow: $adType');
  }

  @override
  void onInterstitialWillAppear(String adType, String provider) {
    print('MAIN.DART >>>> onInterstitialWillAppear: $adType, $provider');
  }

  @override
  void onRewardedCompleted(
      String adProvider, String currencyName, String currencyValue) {
    print(
        'MAIN.DART >>>> onRewardedCompleted: $adProvider, $currencyName, $currencyValue');
  }

  // Banner Callbacks
  @override
  void onBannerClicked() {
    print('MAIN.DART >>>> onBannerClicked');
  }

  @override
  void onBannerAllProvidersFailedToLoad() {
    print('MAIN.DART >>>> onBannerAllProvidersFailedToLoad');
  }

  @override
  void onBannerFailedToLoad() {
    print('MAIN.DART >>>> onBannerFailedToLoad');
  }

  @override
  void onBannerFailedToLoadProvider(String provider) {
    print('MAIN.DART >>>> onBannerFailedToLoadProvider: $provider');
  }

  @override
  void onBannerLoad() {
    print('MAIN.DART >>>> onBannerLoad');
  }
}
