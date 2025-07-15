//
//  AIPIFlyIvwAudioHelper.h
//  
//
//  Created by wxdai on 2018/5/21.
//

#import <Foundation/Foundation.h>
#import "AIPIFlyIvwAudioDelegate.h"
#import "AIPIFlyIvwAudioInitDelegate.h"


@interface AIPIFlyIvwAudioHelper : NSObject
{
     char                        _ivwSid[128];     //  sid
    id<AIPIFlyIvwAudioInitDelegate> _initdelegate;
    
}


@property (nonatomic,copy)NSString *param;

@property(nonatomic, copy) NSMutableDictionary *dictionary;

/**
 * @fn      initIvw
 * @brief   唤醒初始化
 *
 * @param   initdelegate            -[in] 初始化委托对象
 * @param   params              唤醒初始化参数
 */
- (id) initIvw:(id<AIPIFlyIvwAudioInitDelegate>) initdelegate params:(NSString *)params;

/**
 * @fn      startRecord
 * @brief   开始麦克风唤醒
 *
 * @param   delegate            -[in] 唤醒委托对象
 */
- (BOOL) startRecord:(id<AIPIFlyIvwAudioDelegate>) delegate;

/**
 * @fn      stopRecord
 * @brief   结束麦克风唤醒
 */
- (void) stopRecord;

/**
 * @fn      startAudio
 * @brief   音频流唤醒
 *
 * @param   delegate            -[in] 唤醒委托对象
 * @param   audioData              唤醒音频数据
 */
- (BOOL) startAudio:(id<AIPIFlyIvwAudioDelegate>) delegate audioData:(NSData *)audioData;

/**
 * @fn      destroy
 * @brief   唤醒销毁
 */
- (int) destroy;




@end
