//
//  IKKBridgeModel.h
//  GXFlySpeechChat
//
//  Created by 高广校 on 2025/6/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IFKBridgeModel : NSObject

@property (nonatomic, strong) NSString *action;  // 动作
@property (nonatomic, assign) NSInteger callbackId;
@property (nonatomic, strong) NSDictionary<NSString *, id> *data;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *msg;

// 主初始化方法
- (instancetype)initWithCallbackId:(NSInteger)callbackId
                             code:(NSInteger)code
                              msg:(NSString *)msg
                             data:(NSDictionary<NSString *, id> *)data;

// 便捷初始化方法（提供默认参数）
- (instancetype)initWithCallbackId:(NSInteger)callbackId;
- (instancetype)initWithCallbackId:(NSInteger)callbackId code:(NSInteger)code;
- (instancetype)initWithCallbackId:(NSInteger)callbackId code:(NSInteger)code msg:(NSString *)msg;

@end

@interface IFKAuthorizeModel : NSObject

///`record`录音权限、`camera`照相机、`photo`相册权限、`openUri`：打开系统能力
@property (nonatomic, copy) NSString *ability;

//允许选择图片最大数量：默认1张
@property (nonatomic, assign) NSInteger maxImagesCount;

//允许打开系统能力
@property (nonatomic, copy) NSString *uri;
@end

@interface IFKAudioModel : NSObject

/**
 AI+管理平台创建应用时设置的应用ID
 */
@property (nonatomic, copy) NSString *appid;
/**
 内网URl
 */
@property (nonatomic, copy) NSString *url;

///`0`
@property (nonatomic, copy) NSString *force;

@end
NS_ASSUME_NONNULL_END
