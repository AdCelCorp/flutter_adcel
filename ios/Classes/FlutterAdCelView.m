#import <UIKit/UIKit.h>
#import <AdCel/AdCelView.h>
#import "FlutterAdCelView.h"

@interface FlutterAdCelView () <AdCelViewDelegate> {
    NSDictionary *_args;
    
    int64_t _viewId;
    CGRect _frame;
    FlutterMethodChannel* _channel;
    NSObject<FlutterBinaryMessenger>* _messeneger;
}
@property(nonatomic,strong) AdCelView *adCelView;
@end

@implementation FlutterAdCelView

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    self = [super init];
    if (self) {
        if ([args isKindOfClass:[NSDictionary class]]) {
            _args = args;
        }
        _messeneger = messenger;
        _frame = frame;
        _viewId = viewId;
        
        _channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"flutter_adcel/banner_%lld",viewId]
                                               binaryMessenger:messenger];
    }
    return self;
}

- (UIView *)view {
    return [self getOrSetupAdView];
}

- (void)dispose {
    [self.adCelView removeFromSuperview];
    self.adCelView = nil;
    [_channel setMethodCallHandler:nil];
}

- (AdCelView *)getOrSetupAdView {
    if (nil != self.adCelView) {
        return self.adCelView;
    }
    
    if (![_args[@"adSize"] isKindOfClass:[NSString class]])
    {
        return nil;
    }

    self.adCelView = [[AdCelView alloc] initWithBannerSize:_args[@"adSize"] delegate:self];
    self.adCelView.frame = _frame.size.width == 0 ? CGRectMake(0,0,1,1) : _frame;

    __weak typeof(self)weakSelf = self;
    [_channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([@"setListener" isEqualToString:call.method])
        {
            result(nil);
        }
        else if ([@"dispose" isEqualToString:call.method])
        {
            [weakSelf dispose];
            result(nil);
        }
        else if ([@"setRefreshInterval" isEqualToString:call.method])
        {
            NSNumber *interval = call.arguments[@"interval"];
            if (nil!=interval && [interval isKindOfClass:[NSNumber class]]) {
                [weakSelf.adCelView setRefreshInterval:interval.floatValue];
            }
            result(nil);
        }
        else if ([@"loadNextAd" isEqualToString:call.method])
        {
            [weakSelf.adCelView loadNextAd];
            result(nil);
        }
        else {
            result(FlutterMethodNotImplemented);
        }
    }];
    return self.adCelView;
}

#pragma mark - AdCelViewDelegate

-(void)adCelViewDidDisplayAd:(AdCelView*)adCelView providerId:(int)providerId
{
    [_channel invokeMethod:@"onBannerLoad" arguments:nil];
}

-(void)adCelView:(AdCelView*)adCelView failedToDisplayAdWithError:(NSError*)error isConnectionError:(BOOL)isConnectionError
{
    [_channel invokeMethod:@"onBannerFailedToLoad" arguments:nil];
}

-(void)allProvidersFailedToDisplayAdInView:(AdCelView*)adCelView
{
    [_channel invokeMethod:@"onBannerAllProvidersFailedToLoad" arguments:nil];
}

-(void)adCelViewOnClick:(AdCelView*)view providerId:(int)providerId
{
    [_channel invokeMethod:@"onBannerClicked" arguments:nil];
}

@end
