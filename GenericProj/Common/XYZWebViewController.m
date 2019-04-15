//
//  XYZWebViewController.m
//  GenericProj
//
//  Created by Kevin Wu on 6/6/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "XYZWebViewController.h"
#import "XYZWeakScriptMessageHandler.h"

@interface XYZWebViewController () <
    WKNavigationDelegate,
    WKUIDelegate,
    WKScriptMessageHandler
>

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation XYZWebViewController {
  BOOL _loadedEver;
  NSMutableDictionary *_messageMap;
  XYZWeakScriptMessageHandler *_messageHandler;
}

- (id)initWithURL:(NSString *)url
{
  self = [super init];
  if (self) {
    if ( url.length>0 ) {
      _request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
      _loadedEver = NO;
      _messageMap = [[NSMutableDictionary alloc] init];
      _messageHandler = [[XYZWeakScriptMessageHandler alloc] init];
      _messageHandler.delegate = self;
    } else {
      return nil;
    }
  }
  return self;
}

#ifdef DEBUG
- (void)dealloc { XYZPrintMethod(); }
#endif

- (void)viewDidLoad
{
  [super viewDidLoad];

  WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
  _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
  _webView.UIDelegate = self;
  _webView.navigationDelegate = self;
  if ( @available(iOS 11.0, *) ) {
    _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
  } else {
    self.automaticallyAdjustsScrollViewInsets = NO;
  }
  [self.view addSubview:_webView];
  [self clearWebViewCache];
  [self scalePageToFit];


  @weakify(self);

  _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
  [self.view addSubview:_progressView];
  [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.top.left.right.equalTo(self.webView);
  }];
  [self.KVOController observe:_webView keyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> *change) {
    @strongify(self);
    self.progressView.progress = self.webView.estimatedProgress;
    self.progressView.hidden = (self.webView.estimatedProgress>=0.98);
  }];


//  [self subscribeMessage:@"buySong" handler:^(WKUserContentController *ucc, WKScriptMessage *sm) {
//    NSLog(@"buy_song: %@", sm.body);
//  }];

//  NSString *injectJS = @"function injected_func(){ alert(\"Add successfully!!!\"); }";
//  [self injectJavaScript:injectJS];

//  _webView.layer.borderColor = [[UIColor redColor] CGColor];
//  _webView.layer.borderWidth = 1.0;
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];

  _webView.frame = CGRectMake(10.0, 30.0, self.view.bounds.size.width-20.0, self.view.bounds.size.height-40.0);
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  if ( !_loadedEver ) {
    _loadedEver = YES;
    [_webView loadRequest:_request];
  }
}


- (void)loadRequest:(NSURLRequest *)request
{
  _request = request;
  [_webView loadRequest:_request];
}

- (void)clearWebViewCache
{
  NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                  WKWebsiteDataTypeDiskCache,
                                                  //WKWebsiteDataTypeOfflineWebApplicationCache,
                                                  WKWebsiteDataTypeMemoryCache,
                                                  //WKWebsiteDataTypeLocalStorage,
                                                  //WKWebsiteDataTypeCookies,
                                                  //WKWebsiteDataTypeSessionStorage,
                                                  //WKWebsiteDataTypeIndexedDBDatabases,
                                                  //WKWebsiteDataTypeWebSQLDatabases
                                                  ]];
  //// All kinds of data
  //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
  //// Date from
  NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
  //// Execute
  [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
    // Done
  }];
}

- (void)scalePageToFit
{
  NSString *scaleJS = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
  [self injectJavaScript:scaleJS];
}

- (void)injectJavaScript:(NSString *)js
{
  if ( js.length>0 && (_webView) ) {
    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [_webView.configuration.userContentController addUserScript:script];
  }
}


- (void)subscribeMessage:(NSString *)name handler:(void (^)(WKUserContentController *ucc, WKScriptMessage *sm))handler;
{
  if ( name.length>0 ) {
    if ( handler ) {
      [_messageMap setObject:[handler copy] forKey:name];
    } else {
      [_messageMap removeObjectForKey:name];
    }
    [_webView.configuration.userContentController addScriptMessageHandler:_messageHandler name:name];
  }
}

- (void)unsubscribeMessage:(NSString *)name
{
  if ( name.length>0 ) {
    [_messageMap removeObjectForKey:name];
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:name];
  }
}

- (void)unsubscribeAllMessages
{
  @weakify(self);
  [_messageMap enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
    @strongify(self);
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:key];
  }];
  [_messageMap removeAllObjects];
}




- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
  XYZPrintMethod();
  void (^handler)(WKUserContentController *ucc, WKScriptMessage *sm) = [_messageMap objectForKey:message.name];
  if ( handler ) {
    handler(userContentController, message);
  }
}


#pragma mark - WKNavigationDelegate

// Decides whether to allow or cancel a navigation.
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
  XYZPrintMethod();
  decisionHandler(WKNavigationActionPolicyAllow);
}
// Decides whether to allow or cancel a navigation after its response is known.
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
  XYZPrintMethod();
  decisionHandler(WKNavigationResponsePolicyAllow);
}

// Called when web content begins to load in a web view.
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
  XYZPrintMethod();
}
// Called when a web view receives a server redirect.
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
  XYZPrintMethod();
}
// Called when an error occurs while the web view is loading content.
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
  XYZPrintMethod();
}

// Called when the web view begins to receive web content.
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
  XYZPrintMethod();
}
// Called when the navigation is complete.
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
  XYZPrintMethod();
}
// Called when an error occurs during navigation.
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
  XYZPrintMethod();
}

// Called when the web view needs to respond to an authentication challenge.
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
  XYZPrintMethod();
  completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
}

// Called when the web view’s web content process is terminated.
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
  XYZPrintMethod();
}


#pragma mark - WKUIDelegate

// Creates a new web view.
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
  XYZPrintMethod();
  return nil;
}

// Notifies your app that the DOM window closed successfully.
- (void)webViewDidClose:(WKWebView *)webView
{
  XYZPrintMethod();
}

// Determines whether the given element should show a preview.
- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo
{
  XYZPrintMethod();
  return NO;
}
// Called when the user performs a peek action.
- (UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions
{
  XYZPrintMethod();
  return nil;
}
// Called when the user performs a pop action on the preview.
- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController
{
  XYZPrintMethod();
}

// Displays a JavaScript alert panel.
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
  XYZPrintMethod();
  [UIAlertController tk_presentAlert:@"" message:message confirm:@"OK" completion:^{
    if ( completionHandler ) { completionHandler(); }
  }];
}
// Displays a JavaScript confirm panel.
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
  XYZPrintMethod();
  [UIAlertController tk_presentConfirm:@"" message:message cancel:@"Cancel" confirm:@"OK" completion:^(BOOL result) {
    if ( completionHandler ) { completionHandler(result); }
  }];
}
// Displays a JavaScript text input panel.
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler
{
  XYZPrintMethod();
  [UIAlertController tk_presentInput:@"" message:prompt field:^(UITextField *textField) {
    textField.text = defaultText;
  } cancel:@"Cancel" confirm:@"OK" completion:^(BOOL result, NSString *string) {
    if ( completionHandler ) {
      if ( result ) {
        completionHandler(string);
      } else {
        completionHandler(nil);
      }
    }
  }];
}

@end
