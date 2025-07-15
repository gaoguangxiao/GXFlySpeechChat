#import <Foundation/Foundation.h>
#import "AIPIFlyNlpDelegate.h"



@interface AIPIFlyNlp : NSObject
@property(nonatomic, copy) NSString *params;
@property(nonatomic, weak) id<AIPIFlyNlpDelegate> delegate;

- (id)initWithParams:(NSString *)params andDelegate:(id<AIPIFlyNlpDelegate>)delegate;
- (void)nlp:(NSString *)text;

@end
