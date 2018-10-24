//
//  KZWKWebViewJSBridgeDelegate.m
//  iOSApm
//
//  Created by kevin on 2018/9/28.
//  Copyright © 2018年 kevin. All rights reserved.
//

#import "KZWKWebViewJSBridgeDelegate.h"
#import "KZJSBInvokeAction.h"
#import "KZJSBUserContentController.h"

@interface KZWKWebViewJSBridgeDelegate()

@property (nonatomic) id<WKNavigationDelegate> defaultDelegate;
@property (nonatomic, weak) WKWebView* webview;

@end


@implementation KZWKWebViewJSBridgeDelegate

+ (instancetype) bridgeForWebView:(WKWebView *) webview handler:(id) handler {
    KZWKWebViewJSBridgeDelegate* jsbridge = [[KZWKWebViewJSBridgeDelegate alloc] init];
    [jsbridge setUpJSBridge:webview handler:handler];
    return jsbridge;
}

- (void) setUpJSBridge:(WKWebView *) webView handler:(id) handler {
    _webview = webView;
    self.handlerDelegate = handler;
    _webview.navigationDelegate = self;
    
    WKWebViewConfiguration* configution = _webview.configuration;
    if (configution == nil) {
        return;
    }
    KZJSBUserContentController* userController = configution.userContentController;
    [userController setWebview:_webview];
}

- (void) setJSBridgeNavigateDelegate:(id<WKNavigationDelegate>) navDelegate {
    _defaultDelegate = navDelegate;
}

// #progma - uninitiallization
- (void)dealloc
{
    _webview = nil;
    self.handlerDelegate = nil;
    _defaultDelegate = nil;
}

// #progma - WKWebView Navigation Delegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL* Url = navigationAction.request.URL;
    
    if ([self isJSBridgeUrl:Url]) {
        if ([self isJSBActionUrl:Url]) {
            NSLog(@"-->call: %@\n", Url);
            [self KZFlushMessageQueue];
        } else if ([self isJSBLoadUrl:Url]) {
            NSLog(@"-->load bridge: %@\n", Url);
            [self KZLoadBridge];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}


// #progma -
- (void) KZFlushMessageQueue {
    [self.webview evaluateJavaScript:[self jsCmdFetchMessage] completionHandler:^(id _Nullable message, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"--->flush message queue: %@\n", error);
            return ;
        }
        NSLog(@"message: %@\n", message);
        [self handleMessage:message responser:self];
        
    }];
}

- (void) KZLoadBridge {
    [self.webview evaluateJavaScript:[self jsCmdBridgeLoad] completionHandler:^(id _Nullable message, NSError * _Nullable error) {
        NSLog(@"--->load jsBridge: %@\n", error);
    }];
}

// #progma - 
- (void) responseJs:(NSDictionary *) message {
    NSString* cmd = [NSString stringWithFormat:[self jsCmdRecieveResponse], message];
    NSLog(@"--->responseJs cmd: %@\n", cmd);
    [self.webview evaluateJavaScript:cmd completionHandler:^(id _Nullable msg, NSError * _Nullable error) {
        NSLog(@"--->load responseJs: %@\n", error);
    }];
}
@end
