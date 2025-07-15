#import <Foundation/Foundation.h>
#import "AIPIFlyTranslateDelegate.h"



@interface AIPIFlyTranslate : NSObject

@property(nonatomic, copy) NSString *params;
@property(nonatomic, weak) id<AIPIFlyTranslateDelegate> delegate;

- (id)initWithParams:(NSString *)params andDelegate:(id<AIPIFlyTranslateDelegate>)delegate;
- (void)translate:(NSString *)text;
@end
