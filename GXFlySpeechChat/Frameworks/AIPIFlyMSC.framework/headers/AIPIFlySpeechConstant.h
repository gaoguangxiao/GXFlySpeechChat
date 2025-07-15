//
//  AIPIFlySpeechConstant.h
//  MSCDemo
//
//  Created by iflytek on 5/9/14.
//  Copyright (c) 2014 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  公共常量类
 *  主要定义参数的key value值
 */
@interface AIPIFlySpeechConstant : NSObject


#pragma mark - 通用参数key


+ (NSString *)IFlyParam;

/*!
 *  引擎类型。
 *    可选：local，cloud，auto
 *  默认：auto
 *
 *  @return 引擎类型key。
 */
+ (NSString *)ENGINE_TYPE;

/*!
 *  本地识别引擎。
 *
 *  @return 本地识别引擎value。
 */
+ (NSString *)TYPE_LOCAL;

+ (NSString *)COMMON_PATH;

+ (NSString *)SPEAKER_PATH;

/*!
 *  云端识别引擎。
 *
 *  @return 云端识别引擎value。
 */
+ (NSString *)TYPE_CLOUD;


#pragma mark -  合成相关设置key


/*!
 *  合成录音保存路径
 *
 *  @return 合成录音保存路径key
 */
+ (NSString *)TTS_AUDIO_PATH;


/*
 *  云端支持如下发音人：
 *  对于网络TTS的发音人角色，不同引擎类型支持的发音人不同，使用中请注意选择。
 *
 *  |--------|----------------|
 *  |  发音人 |  参数          |
 *  |--------|----------------|
 *  |  小燕   |   xiaoyan     |
 *  |--------|----------------|
 *  |  小宇   |   xiaoyu      |
 *  |--------|----------------|
 *  |  凯瑟琳 |   catherine   |
 *  |--------|----------------|
 *  |  亨利   |   henry       |
 *  |--------|----------------|
 *  |  玛丽   |   vimary      |
 *  |--------|----------------|
 *  |  小研   |   vixy        |
 *  |--------|----------------|
 *  |  小琪   |   vixq        |
 *  |--------|----------------|
 *  |  小峰   |   vixf        |
 *  |--------|----------------|
 *  |  小梅   |   vixl        |
 *  |--------|----------------|
 *  |  小莉   |   vixq        |
 *  |--------|----------------|
 *  |  小蓉   |   vixr        |
 *  |--------|----------------|
 *  |  小芸   |   vixyun      |
 *  |--------|----------------|
 *  |  小坤   |   vixk        |
 *  |--------|----------------|
 *  |  小强   |   vixqa       |
 *  |--------|----------------|
 *  |  小莹   |   vixyin      |
 *  |--------|----------------|
 *  |  小新   |   vixx        |
 *  |--------|----------------|
 *  |  楠楠   |   vinn        |
 *  |--------|----------------|
 *  |  老孙   |   vils        |
 *  |--------|----------------|
 */

/*!
 *  发音人
 *  <table>
 *  <thead>
 *  <tr><th>*云端发音人名称</th><th><em>参数</em></th>
 *  </tr>
 *  </thead>
 *  <tbody>
 *  <tr><td>小燕</td><td>xiaoyan</td></tr>
 *  <tr><td>小宇</td><td>xiaoyu</td></tr>
 *  <tr><td>凯瑟琳</td><td>catherine</td></tr>
 *  <tr><td>亨利</td><td>henry</td></tr>
 *  <tr><td>玛丽</td><td>vimary</td></tr>
 *  <tr><td>小研</td><td>vixy</td></tr>
 *  <tr><td>小琪</td><td>vixq</td></tr>
 *  <tr><td>小峰</td><td>vixf</td></tr>
 *  <tr><td>小梅</td><td>vixl</td></tr>
 *  <tr><td>小莉</td><td>vixq</td></tr>
 *  <tr><td>小蓉(四川话)</td><td>vixr</td></tr>
 *  <tr><td>小芸</td><td>vixyun</td></tr>
 *  <tr><td>小坤</td><td>vixk</td></tr>
 *  <tr><td>小强</td><td>vixqa</td></tr>
 *  <tr><td>小莹</td><td>vixying</td></tr>
 *  <tr><td>小新</td><td>vixx</td></tr>
 *  <tr><td>楠楠</td><td>vinn</td></tr>
 *  <tr><td>老孙</td><td>vils</td></tr>
 *  </tbody>
 *  </table>
 *
 *  @return 发音人key
 */
+ (NSString *)VOICE_NAME;

/*!
 *  音量
 *  注：该参数已无效，使用文档中的参数
 *
 *  @return 音量key
 */
+ (NSString *)VOLUME ;

+ (NSString *)SPEED;

+ (NSString *)PITCH;

/*!
 *  合成音频播放缓冲时间
 *    即缓冲多少秒音频后开始播放，如tts_buffer_time=1000;
 *  默认缓冲1000ms毫秒后播放。
 *
 *  @return 合成音频播放缓冲时间缓冲时间key
 */
+ (NSString *)TTS_BUFFER_TIME ;

/** 合成数据即时返回
 */

/**
 *  合成数据是否即时返回
 *  是否需要数据回调，为1时，当合成一段音频会通过onEvent回调返回，直接合成结束；
 *  设置为1为即时返回；0为非即时返回；默认值为0；
 *
 *  @return 成数据即时返回key
 */
+ (NSString *)TTS_DATA_NOTIFY;

/**
 *  预合成文本
 *
 *  @return 约合成文本参数key
 */
+ (NSString *)NEXT_TEXT;

/**
 *  是否需要打开MPPlayingInfocenter
 *
 *  @return 是否需要打开MPPlayingInfocenter 参数key
 */
+ (NSString *)MPPLAYINGINFOCENTER;

#pragma mark - 识别、听写、语义相关设置key

/*!
 *  录音源
 *    录音时的录音方式，默认为麦克风，设置为1；
 *  如果需要外部送入音频，设置为-1，通过WriteAudio接口送入音频。
 *
 *  @return 录音源key
 */
+ (NSString *)AUDIO_SOURCE;

/*!
 *  识别录音保存路径
 *
 *  @return 识别录音保存路径key
 */
+ (NSString *) ASR_AUDIO_PATH;

#pragma mark - tts
/**
 *  是否自动播放
 */
+ (NSString *)TTS_AUTO_PLAY;

/**
 *  合成结果保存的Uri，注意与TTS_AUDIO_PATH的区别
 */
+ (NSString *)TTS_AUDIO_URI;

//识别参数相关－－－－－⬇️
+ (NSString *) KCIFlySampleRate;

+ (NSString *) KCIFlyAudioSource;

/**
 * 录音回调时间间隔参数, 单位毫秒
 */
+ (NSString *)KCIFlyRecorderMI;


@end
