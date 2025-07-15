//
//  LogManager.h
//  GXFlySpeechChat
//
//  Created by 高广校 on 2025/6/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogManager : NSObject

+ (void)redirectNSLogToDocumentFolder;
+ (NSString *)getLogFilePath;
+ (void)clearLogs;


@end

NS_ASSUME_NONNULL_END
