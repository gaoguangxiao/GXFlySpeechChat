//
//  AIPIFlyIvwAudioInitDelegate.h
//  
//
//  Created by wxdai on 2018/5/21.
//

#import <Foundation/Foundation.h>
@protocol AIPIFlyIvwAudioInitDelegate <NSObject>
- (void) onIvwAudioInit:(NSString *) iresult code:(int)code;
@end
