//
//  IKKBridgeModel.m
//  GXFlySpeechChat
//
//  Created by 高广校 on 2025/6/17.
//

#import "IFKBridgeModel.h"

@implementation IFKBridgeModel

// 主初始化方法
- (instancetype)initWithCallbackId:(NSInteger)callbackId
                             code:(NSInteger)code
                              msg:(NSString *)msg
                             data:(NSDictionary<NSString *, id> *)data {
    self = [super init];
    if (self) {
        _callbackId = callbackId;
        _code = code;
        _msg = msg ?: @"";
        _data = data ?: @{};
    }
    return self;
}

// 便捷初始化方法
- (instancetype)initWithCallbackId:(NSInteger)callbackId {
    return [self initWithCallbackId:callbackId code:0 msg:@"" data:@{}];
}

- (instancetype)initWithCallbackId:(NSInteger)callbackId code:(NSInteger)code {
    return [self initWithCallbackId:callbackId code:code msg:@"" data:@{}];
}

- (instancetype)initWithCallbackId:(NSInteger)callbackId code:(NSInteger)code msg:(NSString *)msg {
    return [self initWithCallbackId:callbackId code:code msg:msg data:@{}];
}

@end

@implementation IFKAuthorizeModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maxImagesCount = 1;
    }
    return self;
}
@end

@implementation IFKAudioModel

@end
