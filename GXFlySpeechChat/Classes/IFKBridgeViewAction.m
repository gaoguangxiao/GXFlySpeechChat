//
//  RSBridgeActionName.m
//  GXFlySpeechChat
//
//  Created by 高广校 on 2025/6/17.
//

#import "IFKBridgeViewAction.h"

IFKBridgeViewAction const IFKBridgeViewActionWebReady = @"webReady";
IFKBridgeViewAction const IFKBridgeViewActionCloseWebview = @"closeWebview";
IFKBridgeViewAction const IFKBridgeViewActionGoBack = @"goBack";
IFKBridgeViewAction const IFKBridgeViewActionStartRecord = @"startRecord";
IFKBridgeViewAction const IFKBridgeViewActionStopRecord  = @"stopRecord";
IFKBridgeViewAction const IFKBridgeViewActionCanIUse  = @"canIUse";
IFKBridgeViewAction const IFKBridgeViewActionUseAbility  = @"useAbility";
IFKBridgeViewAction const IFKBridgeViewActionOpenView  = @"openView";

IFKBridgeViewAction const IFKBridgeViewActionRecognitionEvent = @"recognitionEvent";

NSArray<IFKBridgeViewAction> *RSBridgeViewActionAllCases(void) {
    return @[
        IFKBridgeViewActionWebReady,
        IFKBridgeViewActionCloseWebview,
        IFKBridgeViewActionGoBack
    ];
}
//@implementation IFKBridgeViewAction
//@end
