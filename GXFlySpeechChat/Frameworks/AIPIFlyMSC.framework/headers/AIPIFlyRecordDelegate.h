//
//  AIPIFlyRecordDelegate.h
//  AIPIFlyMSC
//
//  Created by wiser on 2017/6/13.
//  Copyright © 2017年 madianbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AIPIFlyRecordDelegate <NSObject>
- (void)onRecordResult:(NSData *)result epStatus:(int)epStatus;
- (void)onRecordError:(int)code;
- (void)onVolumeChangedEx:(int)volume;
@end
