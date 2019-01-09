//
//  XYZWebViewController.h
//  GenericProj
//
//  Created by Kevin Wu on 6/6/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef void(^XYZWebViewMessageHandler)(WKUserContentController *ucc, WKScriptMessage *sm);


@interface XYZWebViewController : UIViewController <
    WKNavigationDelegate,
    WKUIDelegate,
    WKScriptMessageHandler
>

@property (nonatomic, strong, readonly) WKWebView *webView;
@property (nonatomic, strong) NSURLRequest *request;

@property (nonatomic, strong, readonly) NSDictionary *messageMap;

- (id)initWithRequest:(NSURLRequest *)request;

- (void)scalesPageToFit;

- (void)injectJavaScript:(NSString *)js;

- (void)subscribeMessage:(NSString *)name handler:(XYZWebViewMessageHandler)handler;
- (void)unsubscribeMessage:(NSString *)name;

@end
