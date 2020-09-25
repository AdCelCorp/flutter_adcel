#ifndef AdCelSDKPlugin_h
#define AdCelSDKPlugin_h

#import <UIKit/UIKit.h>
#include "AdCelSDKPluginDefs.h"

#ifndef plAdCelLogLevel
#define plAdCelLogLevel int
#endif

#ifndef ADCEL_PLUGIN_VIEW_SOURCE
#define ADCEL_PLUGIN_VIEW_SOURCE ([[[[UIApplication sharedApplication] keyWindow]rootViewController] view])
#endif

#ifdef __cplusplus
#ifdef ADCEL_USE_C_EXTERN
extern "C"
{
#endif
#endif
    
    void AdCel_start_platform(const char* appId, const char* type);
    void AdCel_setLogLevel_platform(plAdCelLogLevel logLevel);
    bool AdCel_showInterstitial_platform(const char* type);
    void AdCel_showBanner_platform(float x, float y, float width, float height, const char* bannerSize, const char* zone);
    void AdCel_showBannerAtPosition_platform(const char* position, const char* bannerSize, float top, float left, float bottom, float right, const char* zone);
    void AdCel_setBannerRefreshInterval_platform(double refreshInterval);
    void AdCel_loadNextBanner_platform();
    void AdCel_removeAllBanners_platform();
    bool AdCel_hasInterstitial_platform(const char* type);
    bool AdCel_isInterstitialDisplayed_platform();
    void AdCel_setTargetingParam_platform(const char* parameterName, const char* value);
    void AdCel_setUserConsent_platform(bool consent);
    
    const char* AdCel_rewardedCurrency_platform();
    const char* AdCel_rewardedValue_platform();
    
    //Used in Unity platform only
    void AdCel_setUnityCallbackTargetName_platform(const char* targetName);
    
#ifdef __cplusplus
#ifdef ADCEL_USE_C_EXTERN
}
#endif
#endif

#endif
