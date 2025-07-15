//
//  XLWeakScriptMessageDelegate.m
//  RiseEDU
//
//  Created by yu shuhui on 2019/1/10.
//  Copyright © 2019 http://www.risecenter.com. All rights reserved.
//

#import "IFKWeakScriptMessageDelegate.h"

@implementation IFKWeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate{
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
