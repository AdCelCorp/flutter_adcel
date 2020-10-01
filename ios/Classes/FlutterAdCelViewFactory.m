#import <UIKit/UIKit.h>
#import "FlutterAdCelViewFactory.h"
#import "FlutterAdCelView.h"

@implementation FlutterAdCelViewFactory {
    NSObject<FlutterBinaryMessenger>* _messeneger;
}

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger
{
    self = [super init];
    if (self)
    {
        _messeneger = messenger;
    }
    return self;
}

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args
{
    return [[FlutterAdCelView alloc] initWithFrame:frame
                                    viewIdentifier:viewId
                                         arguments:args
                                   binaryMessenger:_messeneger];
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec
{
    return [FlutterStandardMessageCodec sharedInstance];
}

@end
