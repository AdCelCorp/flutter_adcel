import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_adcel/flutter_adcel.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initAdCel();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initAdCel() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   platformVersion = await FlutterAdcel.platformVersion;
    // } on PlatformException {
    //   platformVersion = 'Failed to get platform version.';
    // }

    String key = '';
    if(Platform.isAndroid){
      key = '89fdf849-b5bc-49d0-ad51-0b790e777ae4:fc7094bb-3ca7-4450-9a7e-320b6b4f4e42';
    } else if(Platform.isIOS){
      key = 'ab3d155f-7703-4289-8372-848737c2b879:d949782d-cb74-4501-8f38-613f89a579b9';
    }
    await FlutterAdcel.init(key, ['banner','image','video','interstitial','rewarded']);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          //child: Text('Running on: $_platformVersion\n'),
          child: MaterialButton(
            child: Text('show ad'),
            onPressed: () {
              FlutterAdcel.showInterstitialAd('interstitial');
            },
          ),
        ),
      ),
    );
  }
}
