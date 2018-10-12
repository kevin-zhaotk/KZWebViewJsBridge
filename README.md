# KZWebViewJsBridge
This is a interaction framework between Objective-C and javascript running on iOS!  


Core function: The goal of this framework is supplying a way by which javascript can native methods efficiently. invokation from native to javascript doesnt be referred in this framework right now. I will fill in this funciton later if nessissary.

How to migrate to your project?

add dependency in your Podfile

pod 'KZWebViewJsBridge','~> 1.0.0'

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

<script language="javascript"> ..... function setUpJSBridge() { if (window.WVJavaScriptBridge) {return;} var messageFramge = document.createElement("iframe"); messageFramge.style.display = "none"; messageFramge.src = "kzjsbridge://__kz_jsbridge_load"; document.documentElement.appendChild(messageFramge); setTimeout(function(){document.removeChild(messageFramge)}, 0); } setUpJSBridge() ..... </script>
Inspired by the known opensource project 'WebViewJavascriptBridge', I decided to build this jsbridge. I Copied all signicant theory from WebViewJavascriptBridge except method registration. I think the method registration strategy is unefficient, so i replaced this part by refection.


this is the JSBridge in iOS platform, if you want the same function on android, please visit 

https://github.com/kevin-zhaotk/KZJSbridge

An android one of mine. So your H5 code will exactly one.

