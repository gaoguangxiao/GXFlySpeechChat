//
//  AIPIFlySpeechRecognizerDelegate.h
//  MSC
//
//  Created by ypzhao on 13-3-27.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AIPIFlySpeechError;


/*!
 *  语音识别协议
 *   在使用语音识别时，需要实现这个协议中的方法.
 */
@protocol AIPIFlySpeechRecognizerDelegate <NSObject>

@required

/*!
 *  识别结果回调
 *    在进行语音识别过程中的任何时刻都有可能回调此函数，你可以根据errorCode进行相应的处理，
 *  当errorCode没有错误时，表示此次会话正常结束；否则，表示此次会话有错误发生。特别的当调用
 *  `cancel`函数时，引擎不会自动结束，需要等到回调此函数，才表示此次会话结束。在没有回调此函数
 *  之前如果重新调用了`startListenging`函数则会报错误。
 *
 *  @param errorCode 错误描述
 */
- (void)onErrorEx:(AIPIFlySpeechError *)errorCode;

/*!
 *  识别结果回调
 *    在识别过程中可能会多次回调此函数，你最好不要在此回调函数中进行界面的更改等操作，只需要将回调的结果保存起来。
 */
- (void)onIFlyResultsEx:(NSString *)results isLast:(BOOL)isLast;

@optional

/*!
 *  音量变化回调
 *    在录音过程中，回调音频的音量。
 *
 *  @param volume -[out] 音量，范围从0-100
 */
- (void)onVolumeChangedEx:(int)volume;

/*!
 *  开始录音回调
 *   当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。
 *  如果发生错误则回调onErrorEx:函数
 */
- (void)onBeginOfSpeechEx;

/*!
 *  停止录音回调
 *   当调用了`stopListening`函数或者引擎内部自动检测到断点，如果没有发生错误则回调此函数。
 *  如果发生错误则回调onErrorEx:函数
 */
- (void)onEndOfSpeechEx;

/**
 * 回调返回识别录音数据, 需要设置参数：outbuffer=1
 */
- (void)onRecordBuffer:(NSData *)audioData;

/*!
 *  取消识别回调
 *    当调用了`cancel`函数之后，会回调此函数，在调用了cancel函数和回调onError之前会有一个
 *  短暂时间，您可以在此函数中实现对这段时间的界面显示。
 */
- (void)onCancelEx;

#ifdef _EDUCATION_
/**
 *  返回音频Key
 *
 *  @param key 音频Key
 */
- (void)getAudioKey:(NSString *)key;

#endif

/** 扩展事件回调
 
 根据事件类型返回额外的数据
 
 @param eventType 事件类型，具体参见IFlySpeechEventType的IFlySpeechEventTypeVoiceChangeResult枚举。
 
 */
- (void)onEventEx:(int)eventType arg0Ex:(int)arg0 arg1Ex:(int)arg1 dataEx:(NSData *)eventData;

@end
