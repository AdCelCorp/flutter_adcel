#import "FlutterAdcelPlugin.h"

#import <AdCel/AdCelSDK.h>

#import "AdCelSDKPlugin.h"
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
    if ([@"init" isEqualToString:call.method]) {
        //AdCel_setLogLevel_platform(1);
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


+(void)onInterstitialFirstLoaded:(NSString*)type
{
    [adcelPlugin.mChannel invokeMethod:@"onFirstInterstitialLoad" arguments:@{@"type":type,@"provider":@""}];
}

+(void)onInterstitialWillAppear:(NSString*)type
{
    [adcelPlugin.mChannel invokeMethod:@"onInterstitialWillAppear" arguments:@{@"type":type,@"provider":@""}];
}

+(void)onInterstitialDidDisappear:(NSString*)type
{
    [adcelPlugin.mChannel invokeMethod:@"onInterstitialDidDisappear" arguments:@{@"type":type,@"provider":@""}];
}

+(void)onInterstitialFailedToAppear:(NSString*)type
{
    [adcelPlugin.mChannel invokeMethod:@"onInterstitialFailedToAppear" arguments:@{@"type":type,@"provider":@""}];
}

+(void)onInterstitialClicked:(NSString*)type
{
    [adcelPlugin.mChannel invokeMethod:@"onInterstitialClicked" arguments:@{@"type":type,@"provider":@""}];
}

@end
