//
//  AIPIFlyRecordHelper.h
//  AIPIFlyMSC
//
//  Created by wiser on 2017/6/13.
//  Copyright © 2017年 madianbo. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AIPIFlyISRParam.h"
#import "AIPIFlyRecordDelegate.h"


@interface AIPIFlyRecordHelper : NSObject {
    const char* _result;
    const char* _sid;
    
    int    _index;
    BOOL   _bStop;
    BOOL   _bExit;     //等待recordHandle退出
    NSLock *_nsRecordLock;
}

@property (nonatomic, weak) id<AIPIFlyRecordDelegate> delegate;
@property (nonatomic, copy) NSString *param;
@property (atomic, strong) NSMutableArray *queue;

/**
 * @fn      init
 * @brief   初始化
 *
 * @param   delegate            -[in] 委托对象
 */
- (id)init:(id<AIPIFlyRecordDelegate>)delegate config:(NSString *)sessionConfig;

/**
 * @fn      startRecord
 * @brief   启动录音
 *
 */
- (int)startRecord;

///**
// * @fn      startRecord
// * @brief   启动转化
// *
// */
//- (int) startTransform;

/**
 * @fn      stopRecord
 * @brief   停止
 *
 */
- (BOOL)stopRecord;


- (int)startTransform:(NSData *)datas;

/*
 * @停止转化
 */
- (BOOL)stopTransform;

- (void)clearBuffer;

@end
