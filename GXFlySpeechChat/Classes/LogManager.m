//
//  LogManager.m
//  GXFlySpeechChat
//
//  Created by 高广校 on 2025/6/17.
//

#import "LogManager.h"

@implementation LogManager

+ (void)redirectNSLogToDocumentFolder {
    // 如果已经连接了Xcode调试则不输出到文件
    if (isatty(STDOUT_FILENO)) {
        return;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"console.log"];
    
    // 先删除已存在的文件
    [[NSFileManager defaultManager] removeItemAtPath:logPath error:nil];
    
    // 将NSLog输出重定向到文件
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

+ (NSString *)getLogFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"console.log"];
}

+ (void)clearLogs {
    NSString *logPath = [self getLogFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:logPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:logPath error:nil];
    }
    // 重新打开文件
    freopen([[self getLogFilePath] cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([[self getLogFilePath] cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

@end
