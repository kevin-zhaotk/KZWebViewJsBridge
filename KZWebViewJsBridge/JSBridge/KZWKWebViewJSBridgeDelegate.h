//
//  KZWKWebViewJSBridgeDelegate.h
//  iOSApm
//
//  Created by kevin on 2018/9/28.
//  Copyright © 2018年 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "KZWebViewJSBridgeBase.h"
#import "KZJSBNativeResponseJsDelegate.h"

@interface KZWKWebViewJSBridgeDelegate : KZWebViewJSBridgeBase <WKNavigationDelegate, KZJSBNativeResponseJsDelegate>

+ (instancetype) bridgeForWebView:(WKWebView *) webview handler:(id) handler;

- (void) setUpJSBridge:(WKWebView *) webView handler:(id) handler;

- (void) setJSBridgeNavigateDelegate:(id<WKNavigationDelegate>) navDelegate;


- (void) responseJs:(NSString *) message ;

@end
