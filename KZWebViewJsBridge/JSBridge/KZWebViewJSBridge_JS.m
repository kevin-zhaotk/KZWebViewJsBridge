//
//  KZWebViewJSBridge_JS.m
//  iOSApm
//
//  Created by kevin on 2018/9/29.
//  Copyright © 2018年 kevin. All rights reserved.
//

#import "KZWebViewJSBridge_JS.h"

@implementation KZWebViewJSBridge_JS


+ (NSString *) KZWebViewJSBridge {
    #define __kz_webview_js(x) #x
    
    static NSString* jsCode = @__kz_webview_js(
;(function() {
    if(window.WVJavaScriptBridge) {
        return;
    }
        
    window.WVJavaScriptBridge = {
        callHandler: callHandler,
        fetchMessage: fetchMessage,
        receiveResponse:receiveResponse,
    };
        
    var JSBRIDGE_SCHEME = 'kzjsbridge';
    var JSBRIDGE_CALL_HOST = '__kz_jsbridge_action';
    var JS_BRIDGE_CALL_ACTION = JSBRIDGE_SCHEME + '://' + JSBRIDGE_CALL_HOST;
    var uniqueId = 1;
    var jsbIFrame;
    var responseCallbacks = {};
    var callbackIds = {};
    var sendMessageQueue = [];
    
      
    function callHandler(handlerName, data, responseCallback) {
        if (arguments.length == 2 && typeof data == 'function') {
            responseCallback = data;
            data = null;
        }
        
        _doCall({handler: handlerName, param:data}, responseCallback);
    }
    
    function _doCall(message, responseCallback) {
        if (responseCallback) {
            var callbackId = 'cb_' + (uniqueId++) + '_' + new Date().getTime();
            responseCallbacks[callbackId] = responseCallback;
            message['callbackId'] = callbackId;
        }
        sendMessageQueue.push(message);
        jsbIFrame.src = JS_BRIDGE_CALL_ACTION;
    }
        
    function fetchMessage() {
        message = JSON.stringify(sendMessageQueue);
        sendMessageQueue = [];
        return message;
    }
    
    function receiveResponse(result) {
        var message = result;//JSON.parse(result);
        var callbackId = message.callbackId;
        
        if (callbackId) {
            var responseCallback = responseCallbacks[callbackId];
            if (responseCallback) {
                responseCallback(message.data);
            }
            delete responseCallbacks[callbackId];
        }
    }
    
    jsbIFrame = document.createElement('iFrame');
    jsbIFrame.style.display = 'none';
    jsbIFrame.src = JS_BRIDGE_CALL_ACTION;
    document.documentElement.appendChild(jsbIFrame);
        
})();
    );
#undef __kz_webview_js
    return jsCode;
}
@end
