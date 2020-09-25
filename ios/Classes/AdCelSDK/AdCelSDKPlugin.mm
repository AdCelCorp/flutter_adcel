#include "AdCelSDKPlugin.h"

#include "AdCelSDK.h"
#include "AdCelView.h"
//#include "RNAdCelBannerView.h"

#define ADCEL_onInterstitialFirstLoaded ("onInterstitialFirstLoaded")
#define ADCEL_onInterstitialWillAppear ("onInterstitialWillAppear")
#define ADCEL_onInterstitialDidDisappear ("onInterstitialDidDisappear")
#define ADCEL_onInterstitialFailedToAppear ("onInterstitialFailedToAppear")
#define ADCEL_onInterstitialClicked ("onInterstitialClicked")
#define ADCEL_onBannerDidDisplayAd ("onBannerDidDisplayAd")
#define ADCEL_onBannerFailedToDisplayAd ("onBannerFailedToDisplayAd")
#define ADCEL_onBannerAllProvidersFailedToDisplayAd ("onBannerAllProvidersFailedToDisplayAd")
#define ADCEL_onBannerClicked ("onBannerClicked")
#define ADCEL_onRewardedCompleted ("onRewardedCompleted")

void UnityPause(bool pause);

static NSString* ToNSString(const char* pStr)
{
    if (pStr)
    {
        return [NSString stringWithUTF8String:pStr];
    }
    return nil;
}

static const char* FromNSString(NSString *nsString)
{
    const char *chString = [nsString UTF8String];
    if (chString == NULL)
        return NULL;
    char *resultString = (char*)malloc(strlen(chString) + 1);
    strcpy(resultString, chString);
    return resultString;
}

@interface AdCelSDKPluginName : NSString

+(id)name;

@end

@implementation AdCelSDKPluginName

char* unityAdCelSDK_targetName = NULL;

+(id)name
{
    return [NSString stringWithFormat:@"&plugin=%@", ADCELSDK_PLUGIN_NAME];
}

+(void)onFirstAdLoaded:(NSString*)adType
{
    ADCEL_PLUGIN_CALLBACK_ARG(onInterstitialFirstLoaded, adType.UTF8String);
}

+(void)onAdWillAppear:(NSString*)adType providerId:(int)providerId
{
    ADCEL_PLUGIN_CALLBACK_ARG(onInterstitialWillAppear, adType.UTF8String);
#ifdef UNITY_IOS
    UnityPause(1);
#endif
}

+(void)onAdDidDisappear:(NSString*)adType providerId:(int)providerId
{
#ifdef UNITY_IOS
    UnityPause(0);
#endif
    ADCEL_PLUGIN_CALLBACK_ARG(onInterstitialDidDisappear, adType.UTF8String);
}

+(void)onAdFailedToAppear:(NSString*)adType
{
    ADCEL_PLUGIN_CALLBACK_ARG(onInterstitialFailedToAppear, adType.UTF8String);
}

+(void)adCelViewDidDisplayAd:(AdCelView*)adCelView providerId:(int)providerId
{
    // RNAdCelBannerView* targetView = (RNAdCelBannerView*)adCelView.superview;
    // if (targetView.onBannerDidDisplayAd)
    // {
    //     targetView.onBannerDidDisplayAd(@{});
    // }
}

+(void)adCelView:(AdCelView*)adCelView failedToDisplayAdWithError:(NSError*)error isConnectionError:(BOOL)isConnectionError
{
    // RNAdCelBannerView* targetView = (RNAdCelBannerView*)adCelView.superview;

    // NSString* str = [NSString stringWithFormat:@"%@%@", isConnectionError ? @"Connection Error." : @"", error.localizedDescription];
    
    // if (targetView.onBannerFailedToDisplayAd)
    // {
    //     targetView.onBannerFailedToDisplayAd(@{@"error":(str ? str : @"")});
    // }
}

+(void)allProvidersFailedToDisplayAdInView:(AdCelView*)adCelView
{
    // RNAdCelBannerView* targetView = (RNAdCelBannerView*)adCelView.superview;
    // if (targetView.onBannerAllProvidersFailedToDisplayAd)
    // {
    //     targetView.onBannerAllProvidersFailedToDisplayAd(@{});
    // }
}

+(void)onReward:(int)reward currency:(NSString*)gameCurrency providerId:(int)providerId
{
    NSString* str = [NSString stringWithFormat:@"%d %@", reward, gameCurrency];
    
    ADCEL_PLUGIN_CALLBACK_ARG(onRewardedCompleted,str.UTF8String);
}

+(void)onAdClicked:(NSString*)adType providerId:(int)providerId
{
    ADCEL_PLUGIN_CALLBACK_ARG(onInterstitialClicked, adType.UTF8String);
}

+(void)adCelViewOnClick:(AdCelView*)view providerId:(int)providerId
{
//    RNAdCelBannerView* targetView = (RNAdCelBannerView*)view.superview;
//    if (targetView.onBannerClicked)
//    {
//        targetView.onBannerClicked(@{});
//    }
}

@end

void AdCel_setUnityCallbackTargetName_platform(const char* targetName);

void AdCel_setUnityCallbackTargetName_platform(const char* targetName)
{
    if (NULL != targetName)
    {
        char* _old = unityAdCelSDK_targetName;
        
        char* _unityAdCelSDK_targetName = (char*)malloc(strlen(targetName) + 1);
        
        strcpy(_unityAdCelSDK_targetName, targetName);
        
        unityAdCelSDK_targetName = _unityAdCelSDK_targetName;
        
        if (NULL != _old)
        {
            free(_old);
        }
    }
    
    NSLog(@"Setting unity callback for object with name: %s", unityAdCelSDK_targetName);
}

void AdCel_start_platform(const char* appId, const char* type)
{
    [AdCelSDK setDelegate:(id)[AdCelSDKPluginName class]];
    
    NSString* typeStr = ToNSString(type);
    NSMutableSet* modules = [NSMutableSet new];
    
    if ([typeStr rangeOfString:ADCEL_IMAGE_INTERSTITIAL].location != NSNotFound)
    {
        [modules addObject:ADCEL_IMAGE_INTERSTITIAL];
    }
    
    if ([typeStr rangeOfString:ADCEL_VIDEO_INTERSTITIAL].location != NSNotFound)
    {
        [modules addObject:ADCEL_VIDEO_INTERSTITIAL];
    }
    
    if ([typeStr rangeOfString:ADCEL_INTERSTITIAL].location != NSNotFound)
    {
        [modules addObject:ADCEL_INTERSTITIAL];
    }
    
    if ([typeStr rangeOfString:ADCEL_REWARDED_INTERSTITIAL].location != NSNotFound)
    {
        [modules addObject:ADCEL_REWARDED_INTERSTITIAL];
    }
    
    if ([typeStr rangeOfString:ADCEL_BANNER].location != NSNotFound)
    {
        [modules addObject:ADCEL_BANNER];
    }
    
    [AdCelSDK startWithAppId:ToNSString(appId) modules:modules.allObjects];
}

void AdCel_setLogLevel_platform(plAdCelLogLevel logLevel)
{
    if (0 != logLevel)
    {
        [AdCelSDK enableDebugLogs];
    }
}

bool AdCel_showInterstitial_platform(const char* type)
{
    if (![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            AdCel_showInterstitial_platform(type);
            
        });
        
        return false;
    }
    
#ifdef UNITY_IOS
    return [AdCelSDK showInterstitial:ToNSString(type) fromViewController:UnityGetGLViewController()];
#else
    return [AdCelSDK showInterstitial:ToNSString(type)];
#endif
}

void AdCel_showBanner_platform(float x, float y, float width, float height, const char* bannerSize, const char* zone)
{
    if (![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            AdCel_showBanner_platform(x, y, width, height, bannerSize, zone);
            
        });
        
        return;
    }
    
    AdCelView* banner_view = [[AdCelView alloc]initWithBannerSize:ToNSString(bannerSize) delegate:(id)[AdCelSDKPluginName class]];
    
    banner_view.frame = CGRectMake(x, y, width, height);
    banner_view.zone = ToNSString(zone);
    
    [ADCEL_PLUGIN_VIEW_SOURCE addSubview:banner_view];
}

void AdCel_showBannerAtPosition_platform(const char* position, const char* bannerSize, float marginTop, float marginLeft, float marginBottom, float marginRight, const char* zone)
{
    if (![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            AdCel_showBannerAtPosition_platform(position, bannerSize, marginTop, marginLeft, marginBottom, marginRight, zone);
        });
        
        return;
    }
    
    AdCelView* banner_view = [AdCelView attachToView:ADCEL_PLUGIN_VIEW_SOURCE
                                            position:ToNSString(position)
                                          edgeInsets:UIEdgeInsetsMake(marginTop, marginLeft, marginBottom, marginRight)
                                          bannerSize:ToNSString(bannerSize)
                                            delegate:(id)[AdCelSDKPluginName class]];
    banner_view.zone = ToNSString(zone);
}

void AdCel_setBannerRefreshInterval_platform(double refreshInterval)
{
    if (![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            AdCel_setBannerRefreshInterval_platform(refreshInterval);
            
        });
        
        return;
    }
    
    NSArray* allSubviews = [ADCEL_PLUGIN_VIEW_SOURCE subviews];
    
    for (AdCelView* v in allSubviews)
    {
        if ([v isKindOfClass:[AdCelView class]])
        {
            [v setRefreshInterval:refreshInterval];
        }
    }
}

void AdCel_loadNextBanner_platform()
{
    if (![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            AdCel_loadNextBanner_platform();
            
        });
        
        return;
    }
    
    NSArray* allSubviews = [ADCEL_PLUGIN_VIEW_SOURCE subviews];
    
    for (AdCelView* v in allSubviews)
    {
        if ([v isKindOfClass:[AdCelView class]])
        {
            [v loadNextAd];
        }
    }
}

void AdCel_removeAllBanners_platform()
{
    if (![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            AdCel_removeAllBanners_platform();
            
        });
        
        return;
    }
    
    NSArray* allSubviews = [ADCEL_PLUGIN_VIEW_SOURCE subviews];
    
    for (UIView* v in allSubviews)
    {
        if ([v isKindOfClass:[AdCelView class]])
        {
            [v removeFromSuperview];
        }
    }
}

bool AdCel_hasInterstitial_platform(const char* type)
{
    if (![NSThread isMainThread])
    {
        NSLog(@"Warning: hasInterstitial always returns true if it is run not from the main thread");
        
        return true;
    }
    
    return [AdCelSDK hasInterstitial:ToNSString(type)];
}

bool AdCel_isInterstitialDisplayed_platform()
{
    return [AdCelSDK isInterstitialDisplayed];
}

void AdCel_setTargetingParam_platform(const char* parameterName, const char* value)
{
    [AdCelSDK setTargetingParam:ToNSString(parameterName) value:ToNSString(value)];
}

const char* AdCel_rewardedCurrency_platform()
{
    return FromNSString([AdCelSDK rewardedCurrency]);
}

const char*  AdCel_rewardedValue_platform()
{
    return FromNSString([NSString stringWithFormat:@"%i",[AdCelSDK rewardedValue]]);
}

void AdCel_setUserConsent_platform(bool consent)
{
    [AdCelSDK setUserConsent:consent];
}
