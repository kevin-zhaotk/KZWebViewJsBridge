# KZWebViewJsBridge
This is a interaction framework between Objective-C and javascript running on iOS!  


Core function: The goal of this framework is supplying a way by which javascript can native methods efficiently. invokation from native to javascript doesnt be referred in this framework right now. I will fill in this funciton later if nessissary.

How to migrate to your project?


## 1. JSBridge - private message queue strategy

add dependency in your Podfile

        pod 'KZWebViewJsBridge','~> 1.1.0'

modify your WKWebView initillization

    WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    
    WKPreferences* preference = [[WKPreferences alloc] init];
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    
    config.preferences = preference;
    _webview = [[WKWebView alloc] initWithFrame:self.view.frame];
    
    //_webview.UIDelegate = self;
    
    _bridge = [KZWKWebViewJSBridgeDelegate bridgeForWebView:_webview handler:[UserUtil class]];
    //[delegate setUpJSBridge:_webview webviewDelegate:self handler:nil];
    [self.view addSubview:_webview];

(1) you shouldn't set webview.navigationDelegate, because KZWKWebViewJSBridgeDelegate has already contains this delegate;

(2) handler:[UserUtil class] UserUtil is the class that contains all methods invoked by javascript;


modify your H5 code. Initillize the jsbridge by plugin the following code snippet:

    <script language="javascript"> 
        ..... 
        function setUpJSBridge() { 
            if (window.WVJavaScriptBridge) {return;} 
            var messageFramge = document.createElement("iframe"); 
            messageFramge.style.display = "none"; 
            messageFramge.src = "kzjsbridge://__kz_jsbridge_load"; document.documentElement.appendChild(messageFramge);                 setTimeout(function(){document.removeChild(messageFramge)}, 0); 
        } 
        setUpJSBridge() 
        ..... 
        </script>
        
Inspired by the known open-source project 'WebViewJavascriptBridge', I decided to build this jsbridge. I Copied all signicant theory from WebViewJavascriptBridge except method registration. I think the method registration strategy is unefficient, so i replaced this part by Runtime.


## 2. JSBridge2 - based on WKWebView's javascript message handler
All metohd invocations are encapsulated into a Json String, which transfer from H5 to Native; in H5 side, you just need to invoke a predefined module function to achieve this, 'window.webkit.messageHandlers.ActionInvoke.postMessage';

How to migrate into your project?
1. add this module dependency to your Podfile as mentioned in section 1 above
2. WKWebView initillization, just like refered above JSBridge except one difference; 
        
        config.userContentController = [[WKUserContentController alloc] init];
        replace this line with the following:
        config.userContentController = [[KZJSBUserContentController alloc] init: [UserUtil class]];
        
3. Send a invocation message from H5 to native at appropriate place:
eg: 

        cmd = JSON.stringify({handler:"userId", parameter:"name", callback:"onResult"});
        window.webkit.messageHandlers.ActionInvoke.postMessage(cmd);
        * Attention: your json message should be processed with JSON.stringify in order to compatable with Android
        
this is the JSBridge in iOS platform, if you want the same function on android, please visit 

https://github.com/kevin-zhaotk/KZJSbridge

An android one of mine. So your H5 code will exactly one.

