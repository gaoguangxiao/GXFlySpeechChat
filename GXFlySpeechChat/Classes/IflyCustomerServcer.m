//
//  IflyCustomerServcer.m
//  GXFlySpeechChat
//
//  Created by 高广校 on 2025/6/17.
//

#import "IflyCustomerServcer.h"
#import "IFKWKWebViewController.h"
@interface IflyCustomerServcer()<IFKWKWebViewControllerDelegate>

/// 智能客服控制器
@property (nonatomic, strong) IFKWKWebViewController *customerVc;

@property (nonatomic, assign) BOOL enableLog;

@property (nonatomic, weak) id<IflyCustomerServerSDKDelegate> iflyDelegate;

/// 外界打开智能客服的参数
@property (nonatomic, strong) NSDictionary *originParams;
@end

@implementation IflyCustomerServcer

+ (id)iflyCustomerServcerInstance {
    static IflyCustomerServcer *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [IflyCustomerServcer new];
        manager.enableLog = NO;
    });
    return manager;
}

- (NSInteger)startIflyCustomerServer:(NSDictionary *)params delegate:(id<IflyCustomerServerSDKDelegate>)delegate {
    
    NSString *cid = params[@"cid"]; //核心客户号
    
    NSString *accDisNo = params[@"accDisNo"];//签约主账号脱敏账号
    
    NSString *accSnIN = params[@"accSnIN"];

    self.originParams = params;
    self.iflyDelegate = delegate;
//    {“cid”:”核心客户号”,”accDisNo”:”签约主账号脱敏账号”,”accSnIN”:”签约主账号内联编号”}
    
    //打开控制器
    _customerVc = [IFKWKWebViewController new];
    _customerVc.enableLog = _enableLog;
    _customerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    _customerVc.delegate = self;
    // 方式1：通过 AppDelegate 获取
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window.rootViewController presentViewController:_customerVc animated:YES completion:nil];
    
    NSString *url = params[@"url"];
    [_customerVc loadUrl:url];
    return 1;
}

- (void)closeIflyCustomerServe:(dispatch_block_t)completion {
    
    [_customerVc dismissViewControllerAnimated:true completion:nil];
    
    completion();
}

#pragma mark - IFKWKWebViewControllerDelegate
- (void)webCustomerServerSendEvent:(NSDictionary *)params {
    
    if (self.iflyDelegate && [self.iflyDelegate respondsToSelector:@selector(iflyCustomerServerSendEvent:)]) {
        //operationId：
//        001：打开手机银行功能菜单
//        002：发起电子渠道交易
        
        //其data数据结构有
//        01：data = {“funcitonId”:”菜单id”}；
//        02：data = {“a”：”xxxx”,.....}遵循具体业务接口，只传递用户在智能客服页面录入的数据，其他数据由APP赋值
        NSDictionary *para = @{@"operationId":@"001",
                               @"data":@{}};
        
        //智能客服 明细查询功能
        [self.iflyDelegate iflyCustomerServerSendEvent:para];
    }
}

- (void)iflyCustomerLog:(NSString *)logInfo {
    if (self.iflyDelegate && [self.iflyDelegate respondsToSelector:@selector(iflyCustomerLog:)]) {
        [self.iflyDelegate iflyCustomerLog:logInfo];
    }
}

- (void)sendEvent {
    
//    if (self.iflyDelegate && [self.iflyDelegate respondsToSelector:@selector(iflyCustomerServerSendEvent:)]) {
//        //operationId：
////        001：打开手机银行功能菜单
////        002：发起电子渠道交易
//        
//        //其data数据结构有
////        01：data = {“funcitonId”:”菜单id”}；
////        02：data = {“a”：”xxxx”,.....}遵循具体业务接口，只传递用户在智能客服页面录入的数据，其他数据由APP赋值
//        NSDictionary *para = @{@"operationId":@"001",
//                               @"data":@{}};
//        [self.iflyDelegate iflyCustomerServerSendEvent:para];
//    }
}

#pragma mark - 其他
- (NSString *)getSDKVersion {
    return @"1.0.0";
}

- (void)setLogEnabled:(BOOL)enabled {
    _enableLog = enabled;
}

@end
