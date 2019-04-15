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
  BOOL _loadEver;
  NSMutableDictionary *_messageMap;
  XYZWeakScriptMessageHandler *_messageHandler;
}

- (id)initWithURL:(NSString *)url
{
  self = [super init];
  if (self) {
    if ( url.length>0 ) {
      _request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
      _loadEver = NO;
      _messageMap = [[NSMutableDictionary alloc] init];
      _messageHandler = [[XYZWeakScriptMessageHandler alloc] init];
      _messageHandler.delegate = self;
    } else {
      return nil;
    }
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
  _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
  _webView.UIDelegate = self;
  _webView.navigationDelegate = self;
  if ( @available(iOS 11.0, *) ) {
    [_webView.scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
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
  if ( !_loadEver ) {
    _loadEver = YES;
    [_webView loadRequest:_request];
  }
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


- (void)loadRequest:(NSURLRequest *)request
{
  _request = request;
  [_webView loadRequest:_request];
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



/*! @abstract Decides whether to allow or cancel a navigation.
 @param webView The web view invoking the delegate method.
 @param navigationAction Descriptive information about the action
 triggering the navigation request.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationActionPolicy.
 @discussion If you do not implement this method, the web view will load the request or, if appropriate, forward it to another application.
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
  XYZPrintMethod();
  decisionHandler(WKNavigationActionPolicyAllow);
}

/*! @abstract Decides whether to allow or cancel a navigation after its
 response is known.
 @param webView The web view invoking the delegate method.
 @param navigationResponse Descriptive information about the navigation
 response.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationResponsePolicy.
 @discussion If you do not implement this method, the web view will allow the response, if the web view can show it.
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
  XYZPrintMethod();
  decisionHandler(WKNavigationResponsePolicyAllow);
}

/*! @abstract Invoked when a main frame navigation starts.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
  XYZPrintMethod();
}

/*! @abstract Invoked when a server redirect is received for the main
 frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
  XYZPrintMethod();
}

/*! @abstract Invoked when an error occurs while starting to load data for
 the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
  XYZPrintMethod();
}

/*! @abstract Invoked when content starts arriving for the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
  XYZPrintMethod();
}

/*! @abstract Invoked when a main frame navigation completes.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
  XYZPrintMethod();
}

/*! @abstract Invoked when an error occurs during a committed main frame
 navigation.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
  XYZPrintMethod();
}

/*! @abstract Invoked when the web view needs to respond to an authentication challenge.
 @param webView The web view that received the authentication challenge.
 @param challenge The authentication challenge.
 @param completionHandler The completion handler you must invoke to respond to the challenge. The
 disposition argument is one of the constants of the enumerated type
 NSURLSessionAuthChallengeDisposition. When disposition is NSURLSessionAuthChallengeUseCredential,
 the credential argument is the credential to use, or nil to indicate continuing without a
 credential.
 @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
 */
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
  XYZPrintMethod();
}

/*! @abstract Invoked when the web view's web content process is terminated.
 @param webView The web view whose underlying web content process was terminated.
 */
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0))
{
  XYZPrintMethod();
}




/*! @abstract Creates a new web view.
 @param webView The web view invoking the delegate method.
 @param configuration The configuration to use when creating the new web
 view.
 @param navigationAction The navigation action causing the new web view to
 be created.
 @param windowFeatures Window features requested by the webpage.
 @result A new web view or nil.
 @discussion The web view returned must be created with the specified configuration. WebKit will load the request in the returned web view.

 If you do not implement this method, the web view will cancel the navigation.
 */
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
  XYZPrintMethod();
  return nil;
}

/*! @abstract Notifies your app that the DOM window object's close() method completed successfully.
 @param webView The web view invoking the delegate method.
 @discussion Your app should remove the web view from the view hierarchy and update
 the UI as needed, such as by closing the containing browser tab or window.
 */
- (void)webViewDidClose:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0))
{
  XYZPrintMethod();
}

/*! @abstract Displays a JavaScript alert panel.
 @param webView The web view invoking the delegate method.
 @param message The message to display.
 @param frame Information about the frame whose JavaScript initiated this
 call.
 @param completionHandler The completion handler to call after the alert
 panel has been dismissed.
 @discussion For user security, your app should call attention to the fact
 that a specific website controls the content in this panel. A simple forumla
 for identifying the controlling website is frame.request.URL.host.
 The panel should have a single OK button.

 If you do not implement this method, the web view will behave as if the user selected the OK button.
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
  XYZPrintMethod();
  [UIAlertController tk_presentAlert:@"" message:message confirm:@"OK" completion:^{
    if ( completionHandler ) { completionHandler(); }
  }];
}

/*! @abstract Displays a JavaScript confirm panel.
 @param webView The web view invoking the delegate method.
 @param message The message to display.
 @param frame Information about the frame whose JavaScript initiated this call.
 @param completionHandler The completion handler to call after the confirm
 panel has been dismissed. Pass YES if the user chose OK, NO if the user
 chose Cancel.
 @discussion For user security, your app should call attention to the fact
 that a specific website controls the content in this panel. A simple forumla
 for identifying the controlling website is frame.request.URL.host.
 The panel should have two buttons, such as OK and Cancel.

 If you do not implement this method, the web view will behave as if the user selected the Cancel button.
 */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
  XYZPrintMethod();
  [UIAlertController tk_presentConfirm:@"" message:message cancel:@"Cancel" confirm:@"OK" completion:^(BOOL result) {
    if ( completionHandler ) { completionHandler(result); }
  }];
}

/*! @abstract Displays a JavaScript text input panel.
 @param webView The web view invoking the delegate method.
 @param prompt The message to display.
 @param defaultText The initial text to display in the text entry field.
 @param frame Information about the frame whose JavaScript initiated this call.
 @param completionHandler The completion handler to call after the text
 input panel has been dismissed. Pass the entered text if the user chose
 OK, otherwise nil.
 @discussion For user security, your app should call attention to the fact
 that a specific website controls the content in this panel. A simple forumla
 for identifying the controlling website is frame.request.URL.host.
 The panel should have two buttons, such as OK and Cancel, and a field in
 which to enter text.

 If you do not implement this method, the web view will behave as if the user selected the Cancel button.
 */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *result))completionHandler
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
