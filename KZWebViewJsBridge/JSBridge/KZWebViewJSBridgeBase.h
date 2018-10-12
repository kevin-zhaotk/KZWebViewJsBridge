//
//  KZWebViewJSBridgeBase.h
//  iOSApm
//
//  Created by kevin on 2018/9/28.
//  Copyright © 2018年 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kJSBBridgeScheme @"kzjsbridge"
#define kJSBHostLoad @"__kz_jsbridge_load"
#define kJSBHostAction  @"__kz_jsbridge_action"

@interface KZWebViewJSBridgeBase : NSObject

@property (nonatomic, weak) Class handlerDelegate;     // ALL methods exposed to javascript side should be declared in this delegate class, staticly or not;


- (BOOL) isJSBridgeUrl:(NSURL *) url;

- (BOOL) isJSBActionUrl:(NSURL *) url;

- (BOOL) isJSBLoadUrl:(NSURL *) url;

// javascript function - fetchMessage
- (NSString *) jsCmdFetchMessage ;

// javascript function - loadBridge
- (NSString *) jsCmdBridgeLoad;

- (NSString *) jsCmdRecieveResponse;

// handle javascript handler message, invoke native methods
- (void) handleMessage:(NSString *)message responser:(id) responser;
@end
