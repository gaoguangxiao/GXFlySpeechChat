//
//  RSBridgeActionName.h
//  GXFlySpeechChat
//
//  Created by 高广校 on 2025/6/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * IFKBridgeViewAction NS_STRING_ENUM;
//可用的action
FOUNDATION_EXPORT IFKBridgeViewAction const IFKBridgeViewActionWebReady;
FOUNDATION_EXPORT IFKBridgeViewAction const IFKBridgeViewActionCloseWebview;
FOUNDATION_EXPORT IFKBridgeViewAction const IFKBridgeViewActionGoBack;
FOUNDATION_EXPORT IFKBridgeViewAction const IFKBridgeViewActionStartRecord;
FOUNDATION_EXPORT IFKBridgeViewAction const IFKBridgeViewActionStopRecord;
FOUNDATION_EXPORT IFKBridgeViewAction const IFKBridgeViewActionCanIUse;
FOUNDATION_EXPORT IFKBridgeViewAction const IFKBridgeViewActionUseAbility; //使用某种能力
FOUNDATION_EXPORT IFKBridgeViewAction const IFKBridgeViewActionOpenView;   //打开宿主app
FOUNDATION_EXPORT IFKBridgeViewAction const IFKBridgeViewActionRecognitionEvent;
//@interface IFKBridgeViewAction : NSObject
//
//@end

NS_ASSUME_NONNULL_END
