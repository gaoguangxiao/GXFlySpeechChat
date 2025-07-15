//
//  IFKTWKWebViewController.h
//  GXFlySpeechChat
//
//  Created by 高广校 on 2025/6/17.
//

#import <UIKit/UIKit.h>
#import "IflyCustomerServcer.h"
@class IFKBridgeModel;
//@class IflyCustomerServerSDKDelegate;

NS_ASSUME_NONNULL_BEGIN

#define MyFullLog(fmt, ...) do { \
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; \
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"]; \
    NSString *timestamp = [formatter stringFromDate:[NSDate date]]; \
    NSLog((@"[%@][%s][%@:%d] " fmt), timestamp, __PRETTY_FUNCTION__, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, ##__VA_ARGS__); \
} while(0)

@protocol IFKWKWebViewControllerDelegate <NSObject>

/**
     * @param params  NSDictionary类型，具体格式参考SDK与APP接口交互参数数据格式：web要查询的参数
    */
-(void)webCustomerServerSendEvent:(NSDictionary *)params;

@end

typedef IFKBridgeModel CallWeb;

// 定义回调 block 类型
typedef void (^JSHandleModelCallBlock)(IFKBridgeModel *callBody);

@interface IFKWKWebViewController : UIViewController

@property (nonatomic, weak) id<IFKWKWebViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL enableLog;

- (void)loadUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
