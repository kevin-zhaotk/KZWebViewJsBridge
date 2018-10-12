//
//  KZWebViewJSBridgeBase.m
//  iOSApm
//
//  Created by kevin on 2018/9/28.
//  Copyright © 2018年 kevin. All rights reserved.
//

#import "KZWebViewJSBridgeBase.h"
#import "KZWebViewJSBridge_JS.h"
#import "KZJSBInvokeAction.h"
#import "KZJSBNativeResponseJsDelegate.h"

@interface KZWebViewJSBridgeBase()


@end

@implementation KZWebViewJSBridgeBase

// #progma - initiallization

- (void) initBridge:(id)handler {
    
}


// #progma - url interception adjustment
- (BOOL) isJSBridgeUrl:(NSURL *) url {
    if (url == nil) {
        return NO;
    }
    return [self isJSBLoadUrl:url] || [self isJSBActionUrl:url];
}

- (BOOL) isJSBLoadUrl:(NSURL *) url {
    if (url == nil) {
        return NO;
    }
    NSString* scheme = [url scheme];
    NSString* host = [url host];
    return [self isSchemeMatch:scheme target:kJSBBridgeScheme] && [kJSBHostLoad isEqualToString:host];
}
- (BOOL) isJSBActionUrl:(NSURL *) url {
    if (url == nil) {
        return NO;
    }
    NSString* scheme = [url scheme];
    NSString* host = [url host];
    return [self isSchemeMatch:scheme target:kJSBBridgeScheme] && [kJSBHostAction isEqualToString:host];
}

- (BOOL) isSchemeMatch:(NSString *) scheme target:(NSString *)target {
    if ([target isEqualToString:scheme]) {
        return YES;
    }
    return NO;
}


// #progma - javascript command
- (NSString *) jsCmdFetchMessage {
     return @"WVJavaScriptBridge.fetchMessage();";
}


- (NSString *) jsCmdBridgeLoad {
    NSString* javascript = [KZWebViewJSBridge_JS KZWebViewJSBridge];
    return javascript;
}

- (NSString *) jsCmdRecieveResponse {
    return @"WVJavaScriptBridge.receiveResponse(%@);";
}
// #progma -

/**
 */
- (void) executeOCMethod:(NSString *) json {
    if (json == nil || json.length == 0) {
        NSLog(@"KZWebViewJSBridge receives an empty message, Ignore it!!!");
        return;
    }
    
    
}

- (NSArray *) deserializeJson:(NSString *) json {
    return [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}


// #progma - method invokation
- (void) handleMessage:(NSString *)message responser:(id<KZJSBNativeResponseJsDelegate>) responser {
    
    if (message == nil || message.length == 0) {
        return;
    }
    NSArray* msgArray = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    for (id msg in msgArray) {
        NSString* handler = msg[@"handler"];
        NSString* params = msg[@"param"];
        NSString* callbackId = msg[@"callbackId"];
        NSLog(@"handler: %@,  params: %@, callbackId: %@\n", handler, params, callbackId);
        KZJSBInvokeAction* action = [[KZJSBInvokeAction alloc] initAction:_handlerDelegate handler:handler parameters:params];
        id result = [action action];
        NSLog(@"--->result: %@\n", result);
        [self responseJs:responser callbackId:callbackId message:result];
    }
    
    
}

- (void) responseJs:(id<KZJSBNativeResponseJsDelegate>)responser callbackId:(NSString *) callbackId message:(NSString *)message {
    if (message == nil || callbackId == nil) {
        return;
    }
    NSDictionary* msg = @{@"callbackId": callbackId, @"data":message};
    if ([responser respondsToSelector:@selector(responseJs:)]) {
        NSData* data = [NSJSONSerialization dataWithJSONObject:msg options:0 error:nil];
        NSString* messageJSON = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [responser responseJs:messageJSON];
    }
}
@end
