//
//  XLWeakScriptMessageDelegate.h
//  RiseEDU
//
//  Created by yu shuhui on 2019/1/10.
//  Copyright © 2019 http://www.risecenter.com. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface IFKWeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>


@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;


@end




