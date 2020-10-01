#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterAdCelViewFactory : NSObject<FlutterPlatformViewFactory>
- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger;
@end

NS_ASSUME_NONNULL_END
