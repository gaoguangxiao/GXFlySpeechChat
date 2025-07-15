//
//  NetworkMonitor.m
//  GXFlySpeechChat
//
//  Created by 高广校 on 2025/6/19.
//

#import "NetworkStatusChecker.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

@implementation NetworkStatusChecker

+ (NetworkStatus)currentNetworkStatus {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zeroAddress);
    if (reachability == NULL) {
        return NetworkStatusNotReachable;
    }
    
    SCNetworkReachabilityFlags flags;
    if (!SCNetworkReachabilityGetFlags(reachability, &flags)) {
        CFRelease(reachability);
        return NetworkStatusNotReachable;
    }
    
    CFRelease(reachability);
    
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
        return NetworkStatusNotReachable;
    }
    
    NetworkStatus status = NetworkStatusNotReachable;
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
        status = NetworkStatusReachableViaWiFi;
    }
    
    if (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) != 0) ||
        ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
            status = NetworkStatusReachableViaWiFi;
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
        status = NetworkStatusReachableViaWWAN;
    }
    
    return status;
}

@end
