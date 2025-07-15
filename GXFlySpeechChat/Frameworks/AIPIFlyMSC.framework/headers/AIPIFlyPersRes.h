#import <Foundation/Foundation.h>
#import "AIPIFlyPersResDelegate.h"


@interface AIPIFlyPersRes : NSObject

@property(nonatomic, weak) id<AIPIFlyPersResDelegate> delegate;

- (void)login:(NSString *)params;
- (void)upload:(NSString *)params withData:(NSData *)data;
- (void)download:(NSString *)params;

- (void)uploadEx:(NSString *)params withData:(NSData *)data;
- (void)downloadEx:(NSString *)params;

@end
