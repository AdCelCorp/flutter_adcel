#import "FlutterAdcelPlugin.h"

#import "AdCelSDKPlugin.h"

@implementation FlutterAdcelPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_adcel"
            binaryMessenger:[registrar messenger]];
  FlutterAdcelPlugin* instance = [[FlutterAdcelPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"init" isEqualToString:call.method]) {
      AdCel_setLogLevel_platform(1);
      AdCel_start_platform([call.arguments[@"key"] UTF8String],
                           [[[call.arguments[@"types"] componentsJoinedByString:@","] capitalizedString] UTF8String]);
      result(nil);
  }
  else if ([@"showInterstitialAd" isEqualToString:call.method]) {
      BOOL success = AdCel_showInterstitial_platform([call.arguments[@"type"] UTF8String]);
      result([NSNumber numberWithBool:success]);
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}

@end
