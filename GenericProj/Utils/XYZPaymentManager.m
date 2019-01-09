//
//  XYZPaymentManager.m
//  GenericProj
//
//  Created by Haiping Wu on 2018/10/17.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "XYZPaymentManager.h"

@interface XYZPaymentManager () <
    SKProductsRequestDelegate,
    SKPaymentTransactionObserver
>

@property (nonatomic, assign) BOOL working;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) XYZPaymentCompletionBlock purchaseCompletion;

@property (nonatomic, copy) XYZPaymentCompletionBlock restoreCompletion;

@end


@implementation XYZPaymentManager

static XYZPaymentManager *PaymentManager = nil;

+ (id)sharedObject
{
  if ( !PaymentManager ) {
    PaymentManager = [[self alloc] init];
  }
  return PaymentManager;
}

- (id)init
{
  self = [super init];
  if (self) {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
  }
  return self;
}

- (void)dealloc
{
  [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


// 返回值表示购买流程是否启动成功
- (BOOL)purchase:(NSString *)productId forUser:(NSString *)uid completion:(XYZPaymentCompletionBlock)completion
{
  if ( _working ) {
    XYZLogDebug(@"payment", @"manager is working, just return");
    return [_productId isEqualToString:productId];
  }
  // ================================================================================

  if ( productId.length>0 ) {
    _working = YES;
    self.productId = productId;
    self.uid = uid;
    self.purchaseCompletion = completion;
  } else {
    XYZLogDebug(@"payment", @"product id is nil");
    if ( completion ) {
      completion(nil, [XYZPaymentError invalidProductError]);
    }
    self.productId = nil;
    self.uid = nil;
    self.purchaseCompletion = NULL;
    self.working = NO;
    return NO;
  }


  NSString *receipt = [self IAPReceipt];

  if ( receipt.length>0 ) {
    // 购买失败纪录存在，不走 IAP 流程，提交至后台验证该交易纪录
    XYZLogDebug(@"payment", @"receipt exist, just verify");
    [self verifyReceiptByServer:receipt];
    return YES;
  } else {
    // 不存在购买失败纪录，走 IAP 流程
    XYZLogDebug(@"payment", @"receipt not exist, go buy");

    if ( [SKPaymentQueue canMakePayments] ) {
      // If you have more than one in-app purchase, and would like
      // to have the user purchase a different product, simply define
      // another function and replace kRemoveAdsProductIdentifier with
      // the identifier for the other product

      XYZLogDebug(@"payment", @"user can make payments");

      SKProductsRequest *request =
      [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:_productId]];
      request.delegate = self;
      [request start];

      return YES;

    } else {
      // this is called the user cannot make payments, most likely due to parental controls
      XYZLogDebug(@"payment", @"user cannot make payments due to parental controls");
      [self doneWithError:[XYZPaymentError parentalControlError]];
      return NO;
    }
  }

  return NO;
}


// 提交服务器验证已产生的购买记录（IAP 购买成功，提交服务器失败，产生购买记录，此步骤是验证此购买记录是否已经存在，如果已经存在就不需要再走一次 IAP 流程而是直接提交给后台验证）
- (void)verifyReceiptByServer:(NSString *)receipt
{
  XYZLogDebug(@"payment", @"verify by server");

//  [manager.requestManager POST:buyUrl parameters:defaultParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//    NSDictionary *responseDict = (NSDictionary *)responseObject;
//    if (responseDict) {
//      if ([responseDict.code isEqualToString:SUCCESS_CODE]) {
//        _purchaseCompleted(YES, IAP_ERROR_MSG_00);
//        [self removeFromIAPHistoryFile:[RCClient sharedInstance].loginUser.uid];
//      } else {
//        DLog(@"服务器验证response info:%@", responseDict.info);
//        _purchaseCompleted(NO, IAP_ERROR_MSG_06);
//        //购买失败，将该次购买失败纪录写入plist
//        [self AddToIAPHistoryFile:[RCClient sharedInstance].loginUser.uid iapBase64Str:transactionBase64String];
//      }
//    } else {
//      DLog(@"服务器验证nil");
//      _purchaseCompleted(NO, IAP_ERROR_MSG_06);
//      //购买失败，将该次购买失败纪录写入plist
//      [self AddToIAPHistoryFile:[RCClient sharedInstance].loginUser.uid iapBase64Str:transactionBase64String];
//    }
//  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    DLog(@"服务器验证网络错误:%@", error);
//    _purchaseCompleted(NO, IAP_ERROR_MSG_06);
//    //购买失败，将该次购买失败纪录写入plist
//    [self AddToIAPHistoryFile:[RCClient sharedInstance].loginUser.uid iapBase64Str:transactionBase64String];
//  }];
}


- (void)doneWithError:(NSError *)error
{
  if ( _purchaseCompletion ) {
    _purchaseCompletion(nil, error);
  }
  self.productId = nil;
  self.uid = nil;
  self.purchaseCompletion = NULL;
  _working = NO;
}

- (void)restore:(XYZPaymentCompletionBlock)completion
{
  //this is called when the user restores purchases, you should hook this up to a button
  self.restoreCompletion = completion;
  [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


#pragma mark - SKRequestDelegate

- (void)requestDidFinish:(SKRequest *)request
{
  XYZLogDebug(@"payment", @"request finished");
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
  XYZLogDebug(@"payment", @"request failed");
  [self doneWithError:[XYZPaymentError requestFailedError]];
}


#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
  if( response.products.count>0 ) {
    XYZLogDebug(@"payment", @"products available, do buy");
    SKProduct *product = [response.products firstObject];
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
  } else {
    // this is called if your product id is not valid, this shouldn't be called unless that happens.
    XYZLogDebug(@"payment", @"no products available");
    [self doneWithError:[XYZPaymentError productEmptyError]];
  }
}


#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
  for ( SKPaymentTransaction *transaction in transactions ) {
    switch ( transaction.transactionState ) {
      case SKPaymentTransactionStatePurchasing: {
        // called when the user is in the process of purchasing, do not add any of your own code here.
        XYZLogDebug(@"payment", @"transaction state -> Purchasing");
        break;
      }
      case SKPaymentTransactionStatePurchased: {
        // this is called when the user has successfully purchased the package (Cha-Ching!)
        // you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
        XYZLogDebug(@"payment", @"transaction state -> Purchased");
        NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receiptData = [[NSData alloc] initWithContentsOfURL:receiptURL];
        NSString *receipt = [receiptData base64EncodedStringWithOptions:0];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        [self verifyReceiptByServer:receipt];
        break;
      }
      case SKPaymentTransactionStateRestored: {
        // add the same code as you did from SKPaymentTransactionStatePurchased here
        XYZLogDebug(@"payment", @"transaction state -> Restored");
        NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receiptData = [[NSData alloc] initWithContentsOfURL:receiptURL];
        NSString *receipt = [receiptData base64EncodedStringWithOptions:0];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        [self verifyReceiptByServer:receipt];
        break;
      }
      case SKPaymentTransactionStateFailed: {
        // called when the transaction does not finish
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        if ( transaction.error.code==SKErrorPaymentCancelled ) {
          // the user cancelled the payment :(
          XYZLogDebug(@"payment", @"transaction state -> Cancelled");
          [self doneWithError:[XYZPaymentError userCancelledError]];
        } else {
          XYZLogDebug(@"payment", @"transaction state -> Other than cancelled");
          [self doneWithError:[XYZPaymentError otherFailureError]];
        }
        break;
      }
      case SKPaymentTransactionStateDeferred: {
        XYZLogDebug(@"payment", @"transaction state -> Deferred");
        break;
      }
    }
  }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
  for ( SKPaymentTransaction *transaction in queue.transactions ) {
    if ( transaction.transactionState==SKPaymentTransactionStateRestored ) {
      //called when the user successfully restores a purchase
      XYZLogDebug(@"payment", @"transaction state -> Restored");

      // if you have more than one in-app purchase product,
      // you restore the correct product for the identifier.
      // For example, you could use
      // if ( productID==kRemoveAdsProductIdentifier )
      // to get the product identifier for the
      // restored purchases, you can use
      //
      // NSString *productID = transaction.payment.productIdentifier;

      if ( _restoreCompletion ) {
        _restoreCompletion(transaction, nil);
      }

      [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
  }
}


#pragma mark - Receipt Management

- (NSString *)IAPHistoryFilePath
{
  NSString *path = nil;
  if ( _uid.length>0 ) {
    path = [XYZGlobal pathUser:_uid service:@"Payment" file:nil];
  } else {
    path = [XYZGlobal pathGlobal:@"Payment" file:nil];
  }
  TKCreateDirectory(path);
  return [path stringByAppendingPathComponent:@"IAPHistory.plist"];
}

- (void)createIAPHistoryFile
{
  NSString *path = [self IAPHistoryFilePath];
  if ( ![[NSFileManager defaultManager] fileExistsAtPath:path] ) {
    [[NSFileManager defaultManager] createFileAtPath:path
                                            contents:nil
                                          attributes:nil];
  }
}

- (NSString *)IAPReceipt
{
  NSString *path = [self IAPHistoryFilePath];

  NSDictionary *content = [[NSDictionary alloc] initWithContentsOfFile:path];

  return [content objectForKey:_productId];
}

- (void)addToIAPHistoryFile:(NSString *)receipt
{
  if ( receipt.length<=0 ) {
    XYZLogDebug(@"payment", @"receipt is nil");
    return;
  }

  NSString *path = [self IAPHistoryFilePath];

  NSMutableDictionary *content = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
  if ( !content ) {
    content = [[NSMutableDictionary alloc] init];
  }
  if ( _uid.length>0 ) {
    [content setObject:_uid forKey:@"uid"];
  }
  [content setObject:receipt forKey:_productId];

  [content writeToFile:path atomically:YES];
}

- (void)removeFromIAPHistoryFile
{
  NSString *path = [self IAPHistoryFilePath];

  NSMutableDictionary *content = [[NSMutableDictionary alloc] initWithContentsOfFile:path];

  [content removeObjectForKey:_productId];

  [content writeToFile:path atomically:YES];
}

@end
