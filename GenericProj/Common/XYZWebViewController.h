//
//  XYZWebViewController.h
//  GenericProj
//
//  Created by Kevin Wu on 6/6/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface XYZWebViewController : UIViewController

@property (nonatomic, strong, readonly) WKWebView *webView;
@property (nonatomic, strong, readonly) NSURLRequest *request;

- (id)initWithURL:(NSString *)url;

- (void)loadRequest:(NSURLRequest *)request;

- (void)scalePageToFit;

- (void)injectJavaScript:(NSString *)js;

- (void)subscribeMessage:(NSString *)name handler:(void (^)(WKUserContentController *ucc, WKScriptMessage *sm))handler;
- (void)unsubscribeMessage:(NSString *)name;
- (void)unsubscribeAllMessages;

@end
