//
//  GXViewController.m
//  GXFlySpeechChat
//
//  Created by gaoguangxiao125@sina.com on 06/16/2025.
//  Copyright (c) 2025 gaoguangxiao125@sina.com. All rights reserved.
//

#import "GXViewController.h"
#import "IflyCustomerServcer.h"
#import <GXFlySpeechChat/ISRManager.h>
#import <MJExtension.h>
#import <TKPermissionKit/TKPermissionMicrophone.h>

@interface GXViewController ()<IflyCustomerServerSDKDelegate>

@property (nonatomic, strong) ISRManager *manager;

@property (weak, nonatomic) IBOutlet UITextField *webUrl;

///文本
@property (weak, nonatomic) IBOutlet UITextView *resultText;

@end

@implementation GXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _manager = [ISRManager new];
    
//    _webUrl.text = @"http://172.18.21.222:4000";
    _webUrl.text = @"http://113.44.69.185:8110";
//    http:211.91.71.103:8878/minio/box-im/image/20250714/1752456421039.png
    //进入客服；
    //开始识别
    [[IflyCustomerServcer iflyCustomerServcerInstance] setLogEnabled:true];
}
- (IBAction)进入智能客服:(id)sender {
    
    NSLog(@"webUrl：%@",_webUrl.text);
    
    [[IflyCustomerServcer iflyCustomerServcerInstance] startIflyCustomerServer:@{@"cid":@"123",@"url":_webUrl.text} delegate:self];
    
}

- (IBAction)开始识别:(id)sender {

    [TKPermissionMicrophone authWithAlert:YES completion:^(BOOL isAuth) {
        if (isAuth) {
            IFKAudioModel *fkModel = [IFKAudioModel new];
            fkModel.url = @"211.91.71.103:8888";
            fkModel.appid = @"pc20onli";
            [_manager startISR:fkModel];
        }
    }];
}

- (IBAction)停止识别:(id)sender {
    
    [_manager stopISR];
    
//    [[IflyCustomerServcer iflyCustomerServcerInstance]closeIflyCustomerServe:^{
//        
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IflyCustomerServerSDKDelegate
- (void)iflyCustomerServerSendEvent:(NSDictionary *)params {
    
    //通知宿主app查询具体业务
    NSLog(@"iflyCustomerServerSendEvent: %@",params);
}

- (void)iflyCustomerLog:(NSString *)logInfo {
//    _resultText.text = logInfo;
//    _resultText.text = [NSString stringWithFormat:@"%@\n%@",_resultText.text,logInfo];
}

@end
