//
//  ISRManager.m
//  GXFlySpeechChat
//
//  Created by 高广校 on 2025/6/16.
//

#import "ISRManager.h"
#import <AIPIFlyMSC/AIPIFlySpeechRecognizer.h>
#import <AIPIFlyMSC/AIPIFlySpeechConstant.h>
#import <AIPIFlyMSC/AIPIFlySpeechError.h>
#import <AVFoundation/AVFoundation.h>
@interface ISRManager()<AIPIFlySpeechRecognizerDelegate>

/// 录音识别时保存的文件路径
@property (nonatomic, copy) NSString *pcmPath;

/// 识别的文本
@property (nonatomic, copy) NSString *asr_result;

//识别对象
@property (nonatomic, strong) AIPIFlySpeechRecognizer * iFlySpeechRecognizer;

@end

@implementation ISRManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSpeechRecognizer];
    }
    return self;
}

-(void)initSpeechRecognizer {
    //创建识别
    _iFlySpeechRecognizer = [AIPIFlySpeechRecognizer sharedInstance];
    _iFlySpeechRecognizer.delegate = self;
}

- (BOOL)startISR:(IFKAudioModel *)audioModel{
        
    NSString *appid = audioModel.appid;
    if (!appid) {
        return NO;
    }
//    NSString *time_out = @"10";
    NSString *url = audioModel.url;
    if (!url) {
        return NO;
    }
    
    // 需要保存识别音频时生成音频文件路径
    [self changeFilePath];
    self.asr_result = @"";
//    NSString *auf = @"audio/L16;rate=16000";//audio/L16;rate=16000
//    NSString *svc  = @"iat";
//    NSString *aue  = @"raw";
    NSString *intStr = [NSString stringWithFormat:@"appid=%@,url=%@,auf=audio/L16;rate=16000,svc=iat,aue=raw,extend_params={\"params\":\"eos=30000,bos=30000\"},outbuffer=1",appid,url];
    [_iFlySpeechRecognizer setParameter:intStr forKey:[AIPIFlySpeechConstant IFlyParam]];
    //    [_iFlySpeechRecognizer setParameter:@"40" forKey:[AIPIFlySpeechConstant KCIFlyRecorderMI]];
    //    [_resultView setText:@""];
    //    [_resultView resignFirstResponder];
    //    self.isCanceled = NO;
    
    return [_iFlySpeechRecognizer startListening];
    
//    NSLog(@"ret_startListening=%@", ret?@"YES":@"NO");
//    
//    if (!ret) {
//        //        [_popUpView setText: @"启动识别服务失败，请稍后重试"];//可能是上次请求未结束，暂不支持多路并发
//        //        [self.view addSubview:_popUpView];
//    }
}

- (void)cancelISR {
    //    self.isCanceled = YES;
    NSLog(@"------cancelEx----------");
    [_iFlySpeechRecognizer cancelEx];
    
    //    [_popUpView removeFromSuperview];
    //    [_resultView resignFirstResponder];
}

- (void)stopISR {
    NSLog(@"------stopListening");
    
    [_iFlySpeechRecognizer stopListening];
    
    //    [_resultView resignFirstResponder];
}

#pragma mark - IFlySpeechRecognizerDelegate 必须
/**
 * @fn      onError
 * @brief   识别结束回调
 *
 * @param   error   -[out] 错误类，具体用法见AIPIFlySpeechError
 */
- (void)onErrorEx:(AIPIFlySpeechError *)error
{
    NSLog(@"----onErrorEx errorCode is %d",error.errorCode);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onErrorEx:)]) {
        NSError *errorl = [[NSError alloc]initWithDomain:@"gx.isrError.ex" code:error.errorCode userInfo:@{NSLocalizedDescriptionKey:error.errorDesc}];
        [self.delegate onErrorEx:errorl];
    }
    //    NSString *text ;
    //
    //    if (self.isCanceled) {
    //        text = @"识别取消";
    //    }else if (error.errorCode ==0 ) {
    //        NSString *result = _resultView.text;
    //
    //        if (result.length==0) {
    //            text = @"无识别结果";
    //        }
    //        else
    //        {
    //            text = @"识别成功";
    //        }
    //    }else{
    //        text = [NSString stringWithFormat:@"发生错误：%d ",error.errorCode];
    //        NSLog(@"%@",text);
    //    }
    //
    //    [_popUpView setText: text];
    //    [self.view addSubview:_popUpView];
    
}

- (void)onIFlyResultsEx:(NSString *) results isLast:(BOOL)isLast
{
    NSLog(@"听写结果(json) is %@,isLast is：%d",results, isLast);
    
    //    if (results.length > 0) {
    //        _resultView.text = [NSString stringWithFormat:@"%@\n%@", _resultView.text, results];
    //    }
    //
    NSError *error;
    NSData *data = [results dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    //
    NSString *result = dataDic[@"result"];
    NSInteger pgs = [dataDic[@"pgs"] integerValue];
    if(pgs == 1 && result.length > 0){
        self.asr_result = [NSString stringWithFormat:@"%@%@", self.asr_result, result];
    }
    //
    if(isLast) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.pcmPath]) {
            NSLog(@"==========start================");
            NSLog(@"当前识别文本：%@， 对应pcm音频文件: %@", self.asr_result, self.pcmPath);

            // pcm to wav
            NSString *wavPath = [self.pcmPath stringByReplacingOccurrencesOfString:@".pcm" withString:@".wav"];
            NSString *txtPath = [self.pcmPath stringByReplacingOccurrencesOfString:@".pcm" withString:@".txt"];

            [self addWavHeaderForPcmData:self.pcmPath wavPath:wavPath];
            [self.asr_result writeToFile:txtPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            NSLog(@"文本路径：%@ ||||| 对应wav文件：%@", txtPath, wavPath);
            NSLog(@"===========end================");
            if (self.delegate && [self.delegate respondsToSelector:@selector(onFinishISRRecognizedText:)]) {
                [self.delegate onFinishISRRecognizedText:self.asr_result];
            }
        }
    }
}

#pragma mark - IFlySpeechRecognizerDelegate 可选
- (void)onVolumeChangedEx:(int)volume
{
//    NSLog(@"Demo volume = %d.",volume);
    if (self.delegate && [self.delegate respondsToSelector:@selector(onVolumeChangedEx:)]) {
        [self.delegate onVolumeChangedEx:volume];
    }
}

/**
 * @fn      onBeginOfSpeech
 * @brief   开始识别回调
 */
- (void)onBeginOfSpeechEx
{
    NSLog(@"onBeginOfSpeechEx");
    //    [_popUpView setText: @"正在录音"];
    //    [self.view addSubview:_popUpView];
    
    //    _stopBtn.enabled = YES;
    //    _cancelBtn.enabled  = YES;
}

/**
 * @fn      onEndOfSpeech
 * @brief   停止录音回调
 */
- (void)onEndOfSpeechEx
{
    NSLog(@"onEndOfSpeechEx");
}


- (void)onRecordBuffer:(NSData *)audioData {
    
    // 保存识别音频文件
    [self writeToFile:audioData path:self.pcmPath];
}

/*!
 *  取消识别回调
 *    当调用了`cancel`函数之后，会回调此函数，在调用了cancel函数和回调onError之前会有一个
 *  短暂时间，您可以在此函数中实现对这段时间的界面显示。
 */
- (void)onCancelEx {
    
}


#pragma mark - private
- (void)changeFilePath {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *dir = [NSString stringWithFormat:@"%@/asrAudio", docPath];
    NSString *fileName = [NSString stringWithFormat:@"%ld.pcm", (long)[[NSDate date] timeIntervalSince1970]];
    self.pcmPath = [NSString stringWithFormat:@"%@/%@", dir, fileName]; //[docPath stringByAppendingPathComponent:fileName];
    NSLog(@"pcm path = %@", self.pcmPath);
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&(isDir)]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil];
    }
}

- (void)writeToFile:(NSData *)audioData path:(NSString *)path {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:audioData];
    [fileHandle closeFile];
}

- (void)addWavHeaderForPcmData:(NSString *)filePath wavPath:(NSString *)wavFilePath {

    FILE *fout;
    short NumChannels = 1;       //录音通道数
    short BitsPerSample = 16;    //线性采样位数
    int SamplingRate = 16000;     //录音采样率(Hz)
    int numOfSamples = (int)[[NSData dataWithContentsOfFile:filePath] length];
    
    int ByteRate = NumChannels*BitsPerSample*SamplingRate/8;
    short BlockAlign = NumChannels*BitsPerSample/8;
    int DataSize = NumChannels*numOfSamples*BitsPerSample/8;
    int chunkSize = 16;
    int totalSize = 46 + DataSize;
    short audioFormat = 1;
    
    if((fout = fopen([wavFilePath cStringUsingEncoding:1], "w")) == NULL) {
        NSLog(@"Error opening out file ");
    }
    
    fwrite("RIFF", sizeof(char), 4,fout);
    fwrite(&totalSize, sizeof(int), 1, fout);
    fwrite("WAVE", sizeof(char), 4, fout);
    fwrite("fmt ", sizeof(char), 4, fout);
    fwrite(&chunkSize, sizeof(int),1,fout);
    fwrite(&audioFormat, sizeof(short), 1, fout);
    fwrite(&NumChannels, sizeof(short),1,fout);
    fwrite(&SamplingRate, sizeof(int), 1, fout);
    fwrite(&ByteRate, sizeof(int), 1, fout);
    fwrite(&BlockAlign, sizeof(short), 1, fout);
    fwrite(&BitsPerSample, sizeof(short), 1, fout);
    fwrite("data", sizeof(char), 4, fout);
    fwrite(&DataSize, sizeof(int), 1, fout);
    
    fclose(fout);
    
    NSMutableData *pamdata = [NSMutableData dataWithContentsOfFile:filePath];
    NSFileHandle *handle;
    handle = [NSFileHandle fileHandleForUpdatingAtPath:wavFilePath];
    [handle seekToEndOfFile];
    [handle writeData:pamdata];
    [handle closeFile];
}
@end
