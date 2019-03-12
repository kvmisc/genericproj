//
//  GPTestViewController.m
//  GenericProj
//
//  Created by Kevin Wu on 5/25/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "GPTestViewController.h"
#import <PINRemoteImage/PINImage+DecodedImage.h>

@implementation GPTestViewController

#ifdef DEBUG
- (void)dealloc
{
  XYZPrintMethod();
}
#endif

- (BOOL)shouldLoadContentView
{
  return NO;
}


- (void)viewDidLoad
{
  [super viewDidLoad];

  // iPhone X         1125 x 2436 375 x 812  3      3   image-812h@3x.png 1125*2436
  // iPhone 7P/8P     1080 x 1920 414 x 736  2.608  3
  // iPhone 6P/6sP    1080 x 1920 375 x 667  2.608  3
  // iPhone 6/6s/7/8  750 x 1334  375 x 667  2      2   image-667h@2x.png 750*1334
  // iPhone SE        640 x 1136  320 x 568  2      2   image-568h@2x.png 640*1136

//  UIScreen *screen = [UIScreen mainScreen];
//  NSLog(@"%@ %@ %.04f %.04f", NSStringFromCGSize(screen.bounds.size), NSStringFromCGSize(screen.nativeBounds.size), screen.scale, screen.nativeScale);
//
//  _avatarView.image = [UIImage tk_screenWImageNamed:@"avatar"];

//  UIImage *image1 = [UIImage tk_imageWithColor:[UIColor redColor] size:CGSizeMake(10, 10) s:1];
//  NSLog(@"%@ %f", NSStringFromCGSize(image1.size), image1.scale);
//  NSData *dt1 = UIImageJPEGRepresentation(image1, 0.9);
//  [dt1 writeToFile:TKPathForDocumentResource(@"aaa.jpg") atomically:YES];
//
//  UIImage *image2 = [UIImage tk_imageWithColor:[UIColor greenColor] size:CGSizeMake(10, 10) s:2];
//  NSLog(@"%@ %f", NSStringFromCGSize(image2.size), image2.scale);
//  NSData *dt2 = UIImageJPEGRepresentation(image2, 0.9);
//  [dt2 writeToFile:TKPathForDocumentResource(@"bbb.jpg") atomically:YES];


  {
    UIImage *image1 = [UIImage imageNamed:@"ic_a"];
    NSLog(@"%@ %f", NSStringFromCGSize(image1.size), image1.scale);

    UIImage *image2 = [UIImage tk_decodeImage:image1];
    NSLog(@"%@ %f", NSStringFromCGSize(image2.size), image2.scale);

    UIImage *image3 = [UIImage pin_decodedImageWithCGImageRef:image1.CGImage];
    NSLog(@"%@ %f", NSStringFromCGSize(image3.size), image3.scale);

//    NSString *path = TKPathForBundleResource(nil, @"ic_a.png");
//    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSData *dt1 = UIImageJPEGRepresentation(image2, 0.9);
    [dt1 writeToFile:TKPathForDocumentResource(@"aaa.jpg") atomically:YES];
  }
  NSLog(@" ");
  NSLog(@" ");
  {
    UIImage *image1 = [UIImage imageNamed:@"ic_b"];
    NSLog(@"%@ %f", NSStringFromCGSize(image1.size), image1.scale);

    UIImage *image2 = [UIImage tk_decodeImage:image1];
    NSLog(@"%@ %f", NSStringFromCGSize(image2.size), image2.scale);

    UIImage *image3 = [UIImage pin_decodedImageWithCGImageRef:image1.CGImage];
    NSLog(@"%@ %f", NSStringFromCGSize(image3.size), image3.scale);

    //    NSString *path = TKPathForBundleResource(nil, @"ic_a.png");
    //    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSData *dt1 = UIImageJPEGRepresentation(image2, 0.9);
    [dt1 writeToFile:TKPathForDocumentResource(@"bbb.jpg") atomically:YES];
  }


//  UIImage *image1 = [UIImage imageNamed:@"hill"];
//  _avatarView.image = [image1 tk_cornerRadius:150];

  


//  [self buildReport];

//  @weakify(self);
//  [_button tk_addAction:^(UIButton *bt) {
//    @strongify(self);
//    dispatch_async(dispatch_get_main_queue(), ^{
//      //[self end];
//      //[self doit];
//    });
//  } forControlEvents:UIControlEventTouchUpInside];


//  NSString *originalValue = @"过年回家见家长，在饭桌上得知对方没买车买房后，二老两手一摆，一副要在饭桌上赶人走的架势，这个时候女婿拿出周黑鸭，二老笑逐颜开，不知道周黑鸭想要表达的是怎样的价值观。";
//
//  [_button setTitle:originalValue forState:UIControlStateNormal];

//  _button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//  _button.titleLabel.textAlignment = NSTextAlignmentCenter;
//  _button.titleLabel.numberOfLines = 0;
//  _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//  _button.titleLabel.preferredMaxLayoutWidth = 240;



//  NSMutableAttributedString *displayValue = [[NSMutableAttributedString alloc] initWithString:originalValue];
//
//  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//  paragraphStyle.alignment = NSTextAlignmentFromCTTextAlignment(kCTTextAlignmentLeft);
//  paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//  [displayValue addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [originalValue length])];
//
//  [_button setAttributedTitle:displayValue forState:UIControlStateNormal];

//  [_button tk_addAction:^(UIButton *bt) {
//    NSLog(@"clicked 2");
//    //[UIAlertController tk_presentAlert:@"安全提示" message:@"你现在处境很危险啊，少年！"];
//    [UIAlertController tk_presentConfirm:@"支付确认" message:@"商家要求支付 99 元作为手续费，确定支付吗？" completion:^(BOOL result) {
//      NSLog(@"pay: %d", result);
//    }];
//  } forControlEvents:UIControlEventTouchUpInside];

  //[self begin];
}

- (void)doit
{
//  [UIAlertController tk_presentAlert:@"系统出现严重错误!"];

//  [UIAlertController tk_presentConfirm:nil message:@"确定要退出吗？" cancel:@"取消" confirm:@"确定" completion:^(BOOL result) {
//    NSLog(@"%d", result);
//  }];
//  [UIAlertController tk_presentConfirm:nil message:@"确定要退出吗？" confirm:@"确定" cancel:@"取消" completion:^(BOOL result) {
//    NSLog(@"%d", result);
//  }];

  [UIAlertController tk_presentInput:@"提示信息" message:@"请输入密码：" field:^(UITextField *textField) {
    textField.text = @"abc";
    textField.placeholder = @"10086";
  } cancel:@"取消" confirm:@"确定" completion:^(BOOL result, NSString *string) {
    NSLog(@"%d H%@H", result, string);
  }];
}

- (void)begin
{
}

- (void)end
{
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

- (void)buildReport
{
  NSString *path = TKPathForBundleResource(nil, @"q5-1712.txt");
  NSData *data = [[NSData alloc] initWithContentsOfFile:path];
  NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  NSArray *ary = [string componentsSeparatedByString:@"\n"];
  NSMutableArray *source = [ary mutableCopy];
  NSMutableArray *result = [[NSMutableArray alloc] init];
  for ( NSUInteger i=0; i<[source count]; /**/ ) {
    NSString *str = [source objectAtIndex:i];
    if ( [str hasPrefix:@"1. "] ) {
      [result addObject:[str stringByReplacingOccurrencesOfString:@"1. " withString:@""]];
    } else if ( [str hasPrefix:@"2. "] ) {
      [result addObject:[str stringByReplacingOccurrencesOfString:@"2. " withString:@""]];
    } else if ( [str hasPrefix:@"3. "] ) {
      [result addObject:[str stringByReplacingOccurrencesOfString:@"3. " withString:@""]];
    } else if ( [str hasPrefix:@"4. "] ) {
      [result addObject:[str stringByReplacingOccurrencesOfString:@"4. " withString:@""]];
    }
    [source removeObjectAtIndex:0];
  }

  [result tk_shuffle];

  NSMutableArray *refresh = [[NSMutableArray alloc] init];
  for ( NSString *str in result ) {
    if ( ![refresh tk_hasObjectEqualTo:str] ) {
      [refresh addObject:str];
    }
  }

  NSString *p = TKPathForDocumentResource(@"report.txt");
  TKDeleteFileOrDirectory(p);
  NSMutableArray *write = [[NSMutableArray alloc] init];
  NSUInteger iter = 0;
  for ( NSUInteger i=0; i<24; ++i ) {
    NSUInteger count = 3 + arc4random()%2;
    for ( NSUInteger j=0; j<count; ++j ) {
      NSUInteger idx = iter + j;
      NSLog(@"%lu", (unsigned long)idx);
      NSString *str = [refresh objectAtIndex:idx];
      NSString *res = [NSString stringWithFormat:@"%lu. %@", (unsigned long)(j+1), str];
      [write addObject:res];
    }
    iter += count;
    [write addObject:@"\n"];
  }
  NSString *rr = [write componentsJoinedByString:@"\n"];
  NSData *dt = [rr dataUsingEncoding:NSUTF8StringEncoding];
  [dt writeToFile:p atomically:YES];
}
@end
