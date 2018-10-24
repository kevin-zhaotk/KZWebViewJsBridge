//
//  KZJSBUserContentController.m
//  iOSApm
//
//  Created by kevin on 10/22/18.
//  Copyright © 2018 kevin. All rights reserved.
//

#import "KZJSBUserContentController.h"
#import "JSBridgeModel.h"
#import "KZJSBInvokeAction.h"

static const NSString* JSB_INTERFACE = @"ActionInvoke";

@interface KZJSBUserContentController()

@property (nonatomic) Class handlerDelegate;

@end

@implementation KZJSBUserContentController

- (instancetype) init:(Class) clazz {
    self = [super init];
    _handlerDelegate = clazz;
    [self addScriptMessageHandler:self name:JSB_INTERFACE];
    return self;
}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    if ([message.name isEqualToString:JSB_INTERFACE]) {
        
        JSBridgeModel* model = nil;
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            model = [[JSBridgeModel alloc] initWithJson:message.body];
        } else if ([message.body isKindOfClass:[NSString class]]) {
            model = [[JSBridgeModel alloc] initWithJsonString:message.body];
        } else {
            NSLog(@"message must be instance of NSString or NSDictionary");
            return;
        }
        
        
        KZJSBInvokeAction* action = [[KZJSBInvokeAction alloc] initAction:_handlerDelegate handler:model.handler parameters:model.parameter];
        id result = [action action];
        
        if (result != nil && model.callback != nil && _webview!= nil) {
            NSString* javascript = [[NSString alloc] initWithFormat:@"javascript:%@(\"%@\");", model.callback, result];
            [_webview evaluateJavaScript:javascript completionHandler:^(id _Nullable message, NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"response to js Error: %@\n", error);
                }
            }];
        }
    }
}

@end
