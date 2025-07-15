//
//  NetworkMonitor.h
//  GXFlySpeechChat
//
//  Created by 高广校 on 2025/6/19.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NetworkStatus) {
    NetworkStatusNotReachable = 0,
    NetworkStatusReachableViaWiFi,
    NetworkStatusReachableViaWWAN
};

@interface NetworkStatusChecker : NSObject

+ (NetworkStatus)currentNetworkStatus;

@end
