//
//  IflyCustomerServcer.h
//  GXFlySpeechChat
//
//  Created by 高广校 on 2025/6/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol IflyCustomerServerSDKDelegate <NSObject>

/**
     * @param params  NSDictionary类型，具体格式参考SDK与APP接口交互参数数据格式
    */
-(void)iflyCustomerServerSendEvent:(NSDictionary *)params;

@optional
-(void)iflyCustomerLog:(NSString *)logInfo;

@end

@interface IflyCustomerServcer : NSObject

+ (id)iflyCustomerServcerInstance;


/*
 ** @param params  NSDictionary类型，{“cid”:”核心客户号”,”accDisNo”:”签约主账号脱敏账号”,”accSnIN”:”签约主账号内联编号”}
 * @param delegate  id<IflyCustomerServerSDKDelegate>类型，代理对象
 * @return  NSInteger类型，1：成功， -1失败
 */
- (NSInteger)startIflyCustomerServer:(NSDictionary *)params delegate:(id<IflyCustomerServerSDKDelegate>)delegate;

/**
     * @param completion dispatch_block_t类型，关闭完成，智能客服调用
*/
-(void)closeIflyCustomerServe:(dispatch_block_t)completion;

/**
  获取SDK版本号
 */
- (NSString *)getSDKVersion;

/**
 日志输出控制
 */
- (void)setLogEnabled:(BOOL)enabled;
@end

NS_ASSUME_NONNULL_END
