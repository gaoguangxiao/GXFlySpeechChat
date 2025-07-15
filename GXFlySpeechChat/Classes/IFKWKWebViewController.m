//
//  IFKTWKWebViewController.m
//  GXFlySpeechChat
//
//  Created by 高广校 on 2025/6/17.
//

#import "IFKWKWebViewController.h"
#import "IFKWeakScriptMessageDelegate.h"
#import <WebKit/WebKit.h>
#import "IFKBridgeModel.h"
#import <MJExtension/MJExtension.h>
#import "IflyCustomerServcer.h"
#import "IFKBridgeViewAction.h"
#import "ISRManager.h"

//权限
#import <TKPermissionKit/TKPermissionMicrophone.h>
#import <TKPermissionKit/TKPermissionCamera.h>
#import <TKPermissionKit/TKPermissionPhoto.h>

#import <TZImagePickerController/TZImagePickerController.h>

#import "NetworkStatusChecker.h"
@interface IFKWKWebViewController ()<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ISRManagerDelegate>

@property(nonatomic ,strong)WKWebView *webView;

@property (nonatomic, strong) ISRManager *manager;
@end

@implementation IFKWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.webView];
    self.webView.frame = self.view.frame;
    
    [self addUserScriptForSource:self.jsCode];
    
    //    self.scriptMessageDelegate = self;
    [self addScriptMessageWithName:@"postMessage"];
    
    _manager = [ISRManager new];
    _manager.delegate = self;
}

-(void)loadUrl:(NSString *)url {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark - bridge具体实现
- (void)goBack {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (void)closeWebView {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - app能力
-(void)getRecordAuthorizeWithCallbackId:(NSInteger)callbackId
                             completion:(JSHandleModelCallBlock)block {
    [TKPermissionMicrophone authWithAlert:YES completion:^(BOOL isAuth) {
        block([[CallWeb alloc]initWithCallbackId:callbackId code:isAuth ? 0 : 1]);
    }];
}

-(void)getCameraAuthorizeWithCallbackId:(NSInteger)callbackId
                             completion:(JSHandleModelCallBlock)block {
    [TKPermissionCamera authWithAlert:YES completion:^(BOOL isAuth) {
        block([[CallWeb alloc]initWithCallbackId:callbackId code:isAuth ? 0 : 1]);
    }];
}


-(void)getPhotoAuthorizeWithCallbackId:(NSInteger)callbackId
                            completion:(JSHandleModelCallBlock)block {
    [TKPermissionPhoto authWithAlert:YES level:TKPhotoAccessLevelReadWrite completion:^(BOOL isAuth) {
        block([[CallWeb alloc]initWithCallbackId:callbackId code:isAuth ? 0 : 1]);
    }];
}

-(void)getnetworkAuthorizeWithCallbackId:(NSInteger)callbackId
                            completion:(JSHandleModelCallBlock)block {
    NetworkStatus status = [NetworkStatusChecker currentNetworkStatus];
    switch (status) {
        case NetworkStatusNotReachable:
            NSLog(@"网络不可用");
            break;
        case NetworkStatusReachableViaWiFi:
            NSLog(@"WiFi网络");
            block([[CallWeb alloc]initWithCallbackId:callbackId code:0 msg:@"" data:@{@"isOnline": @"1",@"netType":@"wifi"}]);
//                [[NetworkMonitor sharedInstance] stopMonitoring];
//                block(CallWeb(callbackId: callbackId, data:["isOnline": true,"netType":"wifi"]))
            break;
        case NetworkStatusReachableViaWWAN:
            NSLog(@"蜂窝网络");
            block([[CallWeb alloc]initWithCallbackId:callbackId code:0 msg:@"" data:@{@"isOnline": @"1",@"netType":@"cellular"}]);
            break;
    }

}

#pragma mark - 打开View通信
-(void)openViewWithCallbackId:(NSInteger)callbackId
                     openData:(IFKBridgeModel *)dataModel
                   completion:(JSHandleModelCallBlock)block {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webCustomerServerSendEvent:)]) {
        [self.delegate webCustomerServerSendEvent:dataModel.data];
    }
}

//比如查询明细
- (void)queryTransactionDetail {
    
}

#pragma mark - 打开系统能力
-(void)openUriWithCallbackId:(NSInteger)callbackId
                    openData:(IFKAuthorizeModel *)jsBody
                  completion:(JSHandleModelCallBlock)block {
    // 检查URI是否有效
    NSURL *url = [NSURL URLWithString:jsBody.uri];
    if (jsBody.uri && url) {
        // 检查是否能打开URL
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            block([[CallWeb alloc]initWithCallbackId:callbackId]);
        } else {
            block([[CallWeb alloc]initWithCallbackId:callbackId code:-1 msg:@"uri无法打开"]);
        }
    } else {
        block([[CallWeb alloc]initWithCallbackId:callbackId code:-1 msg:@"uri参数为空"]);
    }
}

#pragma mark - 打开相机
-(void)openCameraWithCallbackId:(NSInteger)callbackId
                       openData:(IFKAuthorizeModel *)dataModel
                     completion:(JSHandleModelCallBlock)block {
    [TKPermissionCamera authWithAlert:YES completion:^(BOOL isAuth) {
        if (isAuth) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
                picker.allowsEditing = YES;
                [self presentViewController:picker animated:YES completion:nil];
            } else {
                block([[CallWeb alloc]initWithCallbackId:callbackId code:-1 msg:@"设备不支持相机"]);
            }
        } else {
            block([[CallWeb alloc]initWithCallbackId:callbackId code:-1 msg:@"暂未授权相机"]);
        }
    }];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    //    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = UIImageJPEGRepresentation(originalImage, 0.9);
        NSString *imageBase64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        //组装图片数据
        CallWeb *cw = [[CallWeb alloc]initWithCallbackId:0];
        cw.action = @"imageEvent";
        cw.data   = @{@"images":imageBase64,
                      @"count":@"1"};
        [self callJSWithBody:cw];
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 打开相册
-(void)openPhotoWithCallbackId:(NSInteger)callbackId
                      openData:(IFKAuthorizeModel *)dataModel
                    completion:(JSHandleModelCallBlock)block {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:dataModel.maxImagesCount delegate:self];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    block([[CallWeb alloc]initWithCallbackId:callbackId code:0]);
}

#pragma mark TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    NSMutableArray *imageBase64s = [NSMutableArray new];
    for (UIImage *image in photos) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
        NSString *imageBase64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        //            NSLog(@"imageBase64:%d",imageBase64.length);
        [imageBase64s addObject:imageBase64];
    }
    //组装图片数据
    CallWeb *cw = [[CallWeb alloc]initWithCallbackId:0];
    cw.action = @"imageEvent";
    cw.data   = @{@"images":imageBase64s,
                  @"count":[NSString stringWithFormat:@"%ld",imageBase64s.count]};
    [self callJSWithBody:cw];
}

#pragma mark - ISRManagerDelegate
- (void)onFinishISRRecognizedText:(NSString *)recognizedText{
    CallWeb *cw = [[CallWeb alloc]initWithCallbackId:0];
    cw.action = @"recognitionEvent";
    cw.data   = @{@"text":recognizedText};
    [self callJSWithBody:cw];
}

- (void)onErrorEx:(NSError *)error {
    CallWeb *cw = [[CallWeb alloc]initWithCallbackId:0];
    cw.action = @"recognitionEvent";
    cw.code   = error.code;
    cw.msg    = error.localizedDescription;
    [self callJSWithBody:cw];
}

- (void)onVolumeChangedEx:(int)volume {
    CallWeb *cw = [[CallWeb alloc]initWithCallbackId:0];
    cw.action = @"recordingEvent";
    cw.data    = @{@"event":@"volume",
                   @"volume":[NSString stringWithFormat:@"%d",volume]};
    [self callJSWithBody:cw];
}

#pragma mark - js功能
- (NSString *)jsCode {
    return @"var nativeBridge = new Object(); \
            nativeBridge.postMessage = function(params) { \
            return window.webkit.messageHandlers.postMessage.postMessage({params}); \
            }";
}

- (void)addUserScriptForSource:(NSString *)source
                 injectionTime:(WKUserScriptInjectionTime)injectionTime
              forMainFrameOnly:(BOOL)forMainFrameOnly {
    
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:source
                                                      injectionTime:injectionTime
                                                   forMainFrameOnly:forMainFrameOnly];
    
    [self.webView.configuration.userContentController addUserScript:userScript];
}

- (void)addUserScriptForSource:(NSString *)source {
    [self addUserScriptForSource:source
                   injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                forMainFrameOnly:NO];
}

- (void)addScriptMessageWithName:(NSString *)name {
    WKUserContentController *userContentController = self.webView.configuration.userContentController;
    IFKWeakScriptMessageDelegate *messageBridge = [[IFKWeakScriptMessageDelegate alloc] initWithDelegate:self];
    [userContentController addScriptMessageHandler:messageBridge name:name];
}

- (void)evaluateJavaScript:(NSString *)javaScriptString {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:javaScriptString completionHandler:nil];
    });
}

- (void)handleWebCallAppWithName:(NSString *)name params:(NSDictionary *)params block:(JSHandleModelCallBlock)block {
    
    if (self.enableLog) {
        NSString *yourMessage = [NSString stringWithFormat:@"web call ios：%@",params.mj_JSONString];
        MyFullLog(@"%@", yourMessage);
        //        if (self.delegate && [self.delegate respondsToSelector:@selector(iflyCustomerLog:)]) {
        //            [self.delegate iflyCustomerLog:yourMessage];
        //        }
    }
    
    if ([name isEqualToString:@"postMessage"]) {
        //解析`params`参数分发请求
        IFKBridgeModel *model = [IFKBridgeModel mj_objectWithKeyValues:params[@"params"]];
        
        if ([model.action isEqualToString:IFKBridgeViewActionCloseWebview]) {
            [self closeWebView];
            block([[CallWeb alloc]initWithCallbackId:model.callbackId code:0]);
        } else if ([model.action isEqualToString:IFKBridgeViewActionGoBack]) {
            [self goBack];
            block([[CallWeb alloc]initWithCallbackId:model.callbackId code:0]);
        } else if ([model.action isEqualToString:IFKBridgeViewActionStartRecord]) {
            IFKAudioModel *authModel = [IFKAudioModel mj_objectWithKeyValues:model.data];
            BOOL b = [_manager startISR:authModel];
            block([[CallWeb alloc]initWithCallbackId:model.callbackId code:b ? 0 : 1 msg: b ? @"" :@"检查url、appid等参数"]);
        } else if ([model.action isEqualToString:IFKBridgeViewActionStopRecord]) {
            IFKAudioModel *authModel = [IFKAudioModel mj_objectWithKeyValues:model.data];
            if ([authModel.force isEqualToString:@"1"]) {
                [_manager cancelISR];
            } else {
                [_manager stopISR];
            }
            block([[CallWeb alloc]initWithCallbackId:model.callbackId code:0]);
        } else if ([model.action isEqualToString:IFKBridgeViewActionOpenView]) {
            [self openViewWithCallbackId:model.callbackId openData:model completion:block];
        } else if ([model.action isEqualToString:IFKBridgeViewActionCanIUse]) {
            IFKAuthorizeModel *authModel = [IFKAuthorizeModel mj_objectWithKeyValues:model.data];
            if ([authModel.ability isEqualToString:@"record"]) {
                [self getRecordAuthorizeWithCallbackId:model.callbackId completion:block];
            } else if ([authModel.ability isEqualToString:@"camera"]) {
                [self getCameraAuthorizeWithCallbackId:model.callbackId completion:block];
            } else if ([authModel.ability isEqualToString:@"photo"]) {
                [self getPhotoAuthorizeWithCallbackId:model.callbackId completion:block];
            } else if ([authModel.ability isEqualToString:@"network"]) {
                [self getnetworkAuthorizeWithCallbackId:model.callbackId completion:block];
            }
        } else if ([model.action isEqualToString:IFKBridgeViewActionUseAbility]) {
            IFKAuthorizeModel *authModel = [IFKAuthorizeModel mj_objectWithKeyValues:model.data];
            if ([authModel.ability isEqualToString:@"record"]) {
                //                [self getRecordAuthorizeWithCallbackId:model.callbackId completion:block];
            } else if ([authModel.ability isEqualToString:@"camera"]) {
                [self openCameraWithCallbackId:model.callbackId openData:authModel completion:block];
            } else if ([authModel.ability isEqualToString:@"photo"]) {
                [self openPhotoWithCallbackId:model.callbackId openData:authModel completion:block];
            } else if ([authModel.ability isEqualToString:@"openUri"]) {
                [self openUriWithCallbackId:model.callbackId openData:authModel completion:block];
            }
        }
    }
}


- (void)callJSWithBody:(IFKBridgeModel *)body {
    [self callJSWithAction:body.action callbackId:body.callbackId data:body.data code:body.code msg:body.msg];
}

- (void)callJSWithAction:(NSString *)action callbackId:(NSInteger)callbackId data:(NSDictionary *)data code:(NSInteger)code msg:(NSString *)msg {
    NSDictionary *dict = @{@"action": action ?: @"",
                           @"data": data ?: @{},
                           @"callbackId": @(callbackId),
                           @"code": @(code),
                           @"msg": msg ?: @""};
    NSString *signedJSON = [dict mj_JSONString];
    if (signedJSON) {
        NSString *javeScriptStr = [NSString stringWithFormat:@"try{JSBridge.callWeb(%@)}catch(e){console.log(e)}", signedJSON];
        if (self.enableLog) {
            MyFullLog(@"%@", javeScriptStr);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //            if (self.delegate && [self.delegate respondsToSelector:@selector(iflyCustomerLog:)]) {
            //                [self.delegate iflyCustomerLog:javeScriptStr];
            //            }
            
            [self.webView evaluateJavaScript:javeScriptStr completionHandler:nil];
        });
    }
}

#pragma mark - WKUserContentController
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:@"postMessage"]) {
        NSDictionary *params = message.body;
        [self handleWebCallAppWithName:message.name params:params block:^(IFKBridgeModel * _Nonnull callBody) {
            [self callJSWithBody:callBody];
        }];
    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}

#pragma mark - WKNavigationDelegate


#pragma mark - Get
-(WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.suppressesIncrementalRendering = YES;
        config.allowsInlineMediaPlayback = YES;//布尔值，指示HTML5视频是否内嵌播放或使用本机全屏控制器
        if (@available(iOS 10.0, *)) {
            config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeAll;
        } else {
            // Fallback on earlier versions
            config.mediaPlaybackRequiresUserAction = NO;
        }
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(12, 0, 0, 0) configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        if (@available(iOS 16.4, *)) {
            _webView.inspectable = YES;
        } else {
            // Fallback on earlier versions
        }
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        //        _webView.scrollView.scrollEnabled  = NO;
    }
    return _webView;
}

@end
