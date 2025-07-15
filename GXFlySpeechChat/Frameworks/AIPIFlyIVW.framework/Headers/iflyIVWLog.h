//
//  iflyIVWLog.h
//  iflyIVWLog
//
//  Created by 伟峰李 on 16/12/22.
//  Copyright © 2016年 伟峰李. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Log(fmt) [NSString stringWithFormat:@"%s [Line %d] %@",__PRETTY_FUNCTION__, __LINE__, fmt]
#define IFLYLog(fmt) [[iflyIVWLog sharedInstance] Dlog:Log(fmt), nil]

@interface iflyIVWLog : NSObject
{
    int curfilesize;
    int curPage;
}

// 日期格式化
@property (nonatomic,retain) NSDateFormatter* dateFormatter;
// 时间格式化
@property (nonatomic,retain) NSDateFormatter* timeFormatter;

// 日志的目录路径
@property (nonatomic,copy) NSString* basePath;

-(void)setSaveFlag:(BOOL)bSave;
-(void)setPrintFlag:(BOOL)bPrint;

-(void)setFileSize:(int)size;

+(id)sharedInstance;
-(void)Dlog:(NSString*) msg, ...;

@end
