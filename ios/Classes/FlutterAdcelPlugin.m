#import "FlutterAdcelPlugin.h"

#import <AdCel/AdCelSDK.h>

#import "FlutterAdCelViewFactory.h"

static FlutterAdcelPlugin* adcelPlugin=nil;

@interface FlutterAdcelPlugin ()
@property(nonatomic,strong) FlutterMethodChannel* mChannel;
@end

@implementation FlutterAdcelPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    adcelPlugin = [[FlutterAdcelPlugin alloc] init];
    
    adcelPlugin.mChannel = [FlutterMethodChannel methodChannelWithName:@"flutter_adcel"
                                                       binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:adcelPlugin channel:adcelPlugin.mChannel];
    
    [registrar registerViewFactory:[[FlutterAdCelViewFactory alloc] initWithBinaryMessenger:[registrar messenger]]
                            withId:@"flutter_adcel/banner"];
}

- (instancetype)initWithMethodChannel:(FlutterMethodChannel *)methodChannel {
    self = [super init];
    if (self) {
        _mChannel = methodChannel;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"init" isEqualToString:call.method])
    {
        [AdCelSDK setDelegate:(id)[self class]];
        
        NSString *types = [[call.arguments[@"types"] componentsJoinedByString:@","] capitalizedString];
        types = [types stringByReplacingOccurrencesOfString:@"Reward" withString:@"Rewarded"];

        [AdCelSDK startWithAppId:call.arguments[@"key"] modules:[types componentsSeparatedByString:@","]];
        result(nil);
    }
    else if ([@"showInterstitialAd" isEqualToString:call.method])
    {
        NSString *type = [call.arguments[@"type"] capitalizedString];
        type = [type stringByReplacingOccurrencesOfString:@"Reward" withString:@"Rewarded"];
        
        BOOL success = [AdCelSDK showInterstitial:type];
        result([NSNumber numberWithBool:success]);
    }
    else if ([@"setLogging" isEqualToString:call.method])
    {
        if ([call.arguments[@"on"] boolValue]) {
            [AdCelSDK enableDebugLogs];
        }
        result(nil);
    }
    else if ([@"setTestMode" isEqualToString:call.method])
    {
        if ([call.arguments[@"on"] boolValue]) {
            [AdCelSDK enableTestMode];
        }
        result(nil);
    }
    else
    {
        result(FlutterMethodNotImplemented);
    }
}

+(void)onFirstAdLoaded:(NSString*)adType
{
    [adcelPlugin.mChannel invokeMethod:@"onFirstInterstitialLoad" arguments:@{@"type":adType,@"provider":@""}];
}

+(void)onAdWillAppear:(NSString*)adType providerId:(int)providerId
{
    [adcelPlugin.mChannel invokeMethod:@"onInterstitialWillAppear"
                             arguments:@{
                                 @"type":adType,
                                 @"provider":[NSString stringWithFormat:@"%i",providerId]
                                 
                             }
     ];
}

+(void)onAdDidDisappear:(NSString*)adType providerId:(int)providerId
{
    [adcelPlugin.mChannel invokeMethod:@"onInterstitialDidDisappear"
                             arguments:@{
                                 @"type":adType,
                                 @"provider":[NSString stringWithFormat:@"%i",providerId]
                             }
     ];
}

+(void)onAdFailedToAppear:(NSString*)adType
{
    [adcelPlugin.mChannel invokeMethod:@"onInterstitialFailedToAppear" arguments:@{@"type":adType,@"provider":@""}];
}

+(void)onAdClicked:(NSString*)adType providerId:(int)providerId
{
    [adcelPlugin.mChannel invokeMethod:@"onInterstitialClicked"
                             arguments:@{
                                 @"type":adType,
                                 @"provider":[NSString stringWithFormat:@"%i",providerId]
                             }
     ];
}

+(void)onReward:(int)reward currency:(NSString*)gameCurrency providerId:(int)providerId
{
    [adcelPlugin.mChannel invokeMethod:@"onRewardedCompleted"
                            arguments:@{
                                @"provider":[NSString stringWithFormat:@"%i",providerId],
                                @"currencyName":gameCurrency,
                                @"currencyValue":[NSString stringWithFormat:@"%i",reward]
                            }
    ];
}

@end
