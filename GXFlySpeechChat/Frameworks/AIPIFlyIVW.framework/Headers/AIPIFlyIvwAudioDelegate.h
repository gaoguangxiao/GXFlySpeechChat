//
//  AIPIFlyIvwAudioDelegate.h
//  
//
//  Created by wxdai on 2018/5/21.
//

#import <Foundation/Foundation.h>
//唤醒回调协议
@protocol AIPIFlyIvwAudioDelegate <NSObject>
/**
 * @fn      onWakeUp
 * @brief   唤醒信息回调
 *
 * @param   iresult          唤醒结果
 * @param   code              唤醒错误码
 */
- (void)onWakeUp:(NSString *)iresult code:(int)code;
/**
 * @fn      onRecordError
 * @brief   唤醒错误码回调
 *
 * @param   code              错误码
 */
- (void)onRecordError:(int) code ;

/**
 * 回调唤醒录音，需要设置参数 output=1
 */
- (void)onRecordBuffer:(NSData *)audioData;

@end
