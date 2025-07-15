//
//  ISRManager.h
//  GXFlySpeechChat
//
//  Created by 高广校 on 2025/6/16.
//



#import <Foundation/Foundation.h>
#import "IFKBridgeModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ISRManagerDelegate <NSObject>

/**
 结束识别时时结束文本
 */
-(void)onFinishISRRecognizedText:(NSString *)recognizedText;

/**
 识别报错
 */
- (void)onErrorEx:(NSError *)error;

/**
 识别时的音量变化
 */
- (void)onVolumeChangedEx:(int)volume;
@end

@interface ISRManager : NSObject

@property (nonatomic, weak) id<ISRManagerDelegate> delegate;

- (BOOL)startISR:(IFKAudioModel *)audioModel;

- (void)cancelISR;

- (void)stopISR;
@end

NS_ASSUME_NONNULL_END
