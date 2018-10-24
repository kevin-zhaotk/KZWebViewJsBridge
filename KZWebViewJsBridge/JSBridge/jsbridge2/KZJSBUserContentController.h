//
//  KZJSBUserContentController.h
//  iOSApm
//
//  Created by kevin on 10/22/18.
//  Copyright © 2018 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface KZJSBUserContentController : WKUserContentController <WKScriptMessageHandler>


@property (nonatomic, weak) WKWebView* webview;

- (instancetype) init:(Class) clazz ;

@end
