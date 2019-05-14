//
//  GPTestViewController.m
//  GenericProj
//
//  Created by Kevin Wu on 5/25/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "GPTestViewController.h"
#import <PINRemoteImage/PINImage+DecodedImage.h>

#import "GPResponderView.h"

#import <QuartzCore/QuartzCore.h>

#import <os/lock.h>



void bubble_sort(int arr[], int len) {

  for ( int i=0; i<len-1; i++ ) {
    //printf("%d:", i);
    for ( int j=0; j<len-1-i; j++ ) {
      if ( arr[j]>arr[j+1] ) {
        int temp = arr[j];
        arr[j] = arr[j+1];
        arr[j+1] = temp;
      }
      printf("[%d %d]: %d %d %d %d %d\n", i, j, arr[0], arr[1], arr[2], arr[3], arr[4]);
    }
    printf("\n");
  }
}

@implementation GPTestViewController {
  CALayer *_greenLayer;
  CALayer *_blueLayer;
}

//#ifdef DEBUG
//- (void)dealloc
//{
//  XYZPrintMethod();
//}
//#endif

- (BOOL)shouldLoadContentView
{
  return NO;
}

//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//  //[super touchesBegan:touches withEvent:event];
//  NSLog(@"vc touch began");
//
////  NSLog(@"%@", BASE_URL);
////  _titleLabel.text = BASE_URL;
////
////  //[self.displayView setNeedsDisplay];
////  [_blueLayer display];
//
//  CGPoint point1 = [[touches anyObject] locationInView:self.view];
//  CGPoint point = [[touches anyObject] locationInView:_displayView];
//  NSLog(@"%@ %@", NSStringFromCGPoint(point1), NSStringFromCGPoint(point));
//  CALayer *layer = [_displayView.layer hitTest:point];
//  if ( layer==_blueLayer ) {
//    NSLog(@"blue layer touched");
//  } else if ( layer==_greenLayer ) {
//    NSLog(@"green layer touched");
//  }
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//  //[super touchesMoved:touches withEvent:event];
//  NSLog(@"vc touch moved");
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//  //[super touchesCancelled:touches withEvent:event];
//  NSLog(@"vc touch cancelled");
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//  //[super touchesEnded:touches withEvent:event];
//  //NSLog(@"vc touch ended");
//}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];

  //_displayView.frame = CGRectMake(40, 40, 150, 150);
}


- (void)setUpTimer
{
  // 获取主队列
  dispatch_queue_t queue = dispatch_get_main_queue();
  // 创建定时器, 在主线程中调用
  dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
  // 2秒后执行
  NSTimeInterval start = 2.0;
  // 执行间隔1秒
  NSTimeInterval interval = 1.0;
  // 设置定时器
  dispatch_source_set_timer(timer,
                            dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC),
                            interval * NSEC_PER_SEC,
                            0);
  // 设置回调
  __weak typeof(self) weakSelf = self;
  dispatch_source_set_event_handler(timer, ^{
    NSLog(@"in timer");
    [weakSelf timerTest];
  });
  // 启动定时器
  dispatch_resume(timer);
  self.timer = timer;
}

- (void)timerTest
{
  NSLog(@"%s", __func__);
}

- (void)dealloc
{
  NSLog(@"%s", __func__);
}


- (void)viewDidLoad
{
  [super viewDidLoad];

  os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;

  os_unfair_lock_lock(&lock);
  os_unfair_lock_unlock(&lock);

  return;



//  self.view.backgroundColor = [UIColor tk_colorWithHexInteger:0xff000033];
//
//  [self setUpTimer];

//  {
//    CALayer *layer = [CALayer layer];
//    layer.frame = CGRectMake(10, 10, 280, 280);
//    layer.backgroundColor = [[UIColor greenColor] CGColor];
//    [_displayView.layer addSublayer:layer];
//    _greenLayer = layer;
//  }
  {
//    CALayer *layer = [CALayer layer];
//    layer.frame = CGRectMake(50, 50, 100, 100);
//    //layer.backgroundColor = [[UIColor blueColor] CGColor];
//    [_displayView.layer addSublayer:layer];
//    _blueLayer = layer;
//
//    UIImage *image = [UIImage imageNamed:@"line"];
//    _blueLayer.contents = (__bridge id)[image CGImage];
//
//    _blueLayer.shadowColor = [[UIColor redColor] CGColor];
//    _blueLayer.shadowOpacity = 1.0;
//    _blueLayer.shadowOffset = CGSizeMake(-2.0, 10.0);
//    _blueLayer.shadowRadius = 10.0;
  }

//  self.view.backgroundColor = [UIColor whiteColor];
//  _displayView.backgroundColor = [UIColor clearColor];

//  UIImage *image = [UIImage imageNamed:@"mickey"];
//  _displayView.layer.contents = (__bridge id)[image CGImage];

//  _displayView.layer.shadowColor = [[UIColor redColor] CGColor];
//  _displayView.layer.shadowOpacity = 1.0;
//  _displayView.layer.shadowOffset = CGSizeMake(-2.0, 10.0);
//  _displayView.layer.shadowRadius = 10.0;

//  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//  [self.view addSubview:button];
//  button.frame = CGRectMake(50, 50, 80, 40);
//  [button setTitle:@"ASDF" forState:UIControlStateNormal];
//  button.backgroundColor = [UIColor whiteColor];
//  button.titleLabel.backgroundColor = [UIColor whiteColor];
//  button.alpha = 0.5;
//  button.layer.shouldRasterize = NO;

  UIView *boxView = [[UIView alloc] init];
  boxView.backgroundColor = [UIColor whiteColor];
  boxView.frame = CGRectMake(50, 100, 150, 50);
  [self.view addSubview:boxView];

  UILabel *label = [[UILabel alloc] init];
  label.frame = CGRectMake(30, 10, 90, 30);
  label.backgroundColor = [UIColor whiteColor];
  [boxView addSubview:label];
  label.textColor = [UIColor blackColor];
  label.textAlignment = NSTextAlignmentCenter;
  label.text = @"ASDF";

  boxView.alpha = 0.5;
  NSLog(@"%d", boxView.layer.shouldRasterize);


//  CALayer *maskLayer = [CALayer layer];
//  maskLayer.frame = _displayView.bounds;
//  UIImage *maskImage = [UIImage imageNamed:@"mask_blue"];
//  maskLayer.contents = (__bridge id)maskImage.CGImage;
//  maskLayer.contentsGravity = kCAGravityResize;
//  _displayView.layer.mask = maskLayer;
//
//  _displayView.layer.borderWidth = 1.0;
//  _displayView.layer.borderColor = [[UIColor redColor] CGColor];
//
//  maskLayer.borderWidth = 1.0;
//  maskLayer.borderColor = [[UIColor greenColor] CGColor];




//  _displayView.layer.cornerRadius = 10.0;
//  _displayView.layer.masksToBounds = YES;

//  UIView *redView = [[UIView alloc] init];
//  redView.backgroundColor = [UIColor redColor];
//  redView.frame = CGRectMake(0, 0, 50, 50);
//  [_displayView addSubview:redView];
//
//  _displayView.layer.cornerRadius = 10.0;
//  //_displayView.layer.masksToBounds = YES;

//  _displayView.layer.borderColor = [[UIColor redColor] CGColor];
//  _displayView.layer.borderWidth = 10.0;






//  int arr[] = { 3, 5, 1, 4, 2 };
//  bubble_sort(arr, 5);


//  GPResponderView *v1 = [[GPResponderView alloc] init];
//  v1.backgroundColor = [UIColor redColor];
//  v1.name = @"111";
//  [self.view addSubview:v1];
//  v1.frame = CGRectMake(50, 50, 100, 100);
//
//  GPResponderView *v2 = [[GPResponderView alloc] init];
//  v2.backgroundColor = [UIColor greenColor];
//  v2.name = @"222";
//  [self.view addSubview:v2];
//  v2.frame = CGRectMake(100, 100, 100, 100);
//
//  v1.layer.zPosition = 2.0;

//  self.view.layer.cornerRadius = 5;

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


//  {
//    UIImage *image1 = [UIImage imageNamed:@"ic_a"];
//    NSLog(@"%@ %f", NSStringFromCGSize(image1.size), image1.scale);
//
//    UIImage *image2 = [UIImage tk_decodeImage:image1];
//    NSLog(@"%@ %f", NSStringFromCGSize(image2.size), image2.scale);
//
//    UIImage *image3 = [UIImage pin_decodedImageWithCGImageRef:image1.CGImage];
//    NSLog(@"%@ %f", NSStringFromCGSize(image3.size), image3.scale);
//
////    NSString *path = TKPathForBundleResource(nil, @"ic_a.png");
////    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//    NSData *dt1 = UIImageJPEGRepresentation(image2, 0.9);
//    [dt1 writeToFile:TKPathForDocumentResource(@"aaa.jpg") atomically:YES];
//  }
//  NSLog(@" ");
//  NSLog(@" ");
//  {
//    UIImage *image1 = [UIImage imageNamed:@"ic_b"];
//    NSLog(@"%@ %f", NSStringFromCGSize(image1.size), image1.scale);
//
//    UIImage *image2 = [UIImage tk_decodeImage:image1];
//    NSLog(@"%@ %f", NSStringFromCGSize(image2.size), image2.scale);
//
//    UIImage *image3 = [UIImage pin_decodedImageWithCGImageRef:image1.CGImage];
//    NSLog(@"%@ %f", NSStringFromCGSize(image3.size), image3.scale);
//
//    //    NSString *path = TKPathForBundleResource(nil, @"ic_a.png");
//    //    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//    NSData *dt1 = UIImageJPEGRepresentation(image2, 0.9);
//    [dt1 writeToFile:TKPathForDocumentResource(@"bbb.jpg") atomically:YES];
//  }


//  {
//    UIImage *image1 = [UIImage imageNamed:@"haa"];
//    NSLog(@"%@ %f", NSStringFromCGSize(image1.size), image1.scale);
//    UIImage *image2 = [image1 tk_roundedCornerImage:26];
//    NSLog(@"%@ %f", NSStringFromCGSize(image2.size), image2.scale);
//    _avatarView.image = image2;
//  }
//  {
//    UIImage *image1 = [UIImage imageNamed:@"haa"];
//    NSLog(@"%@ %f", NSStringFromCGSize(image1.size), image1.scale);
//    UIImage *image2 = [image1 tk_roundedCornerImage:30];
//    NSLog(@"%@ %f", NSStringFromCGSize(image2.size), image2.scale);
//    _avatarView.image = image2;
//  }

  {
//    UIImage *image = [UIImage imageNamed:@"mickey"];
//    _displayView.layer.contents = (__bridge id)[image CGImage];

//    // 类似于 UIView 的 clipsToBounds 属性
//    _displayView.layer.masksToBounds = YES;
//
//    // 类似于 UIView 的 contentMode 属性
//    _displayView.layer.contentsGravity = kCAGravityCenter;
//
//    // 定义了寄宿图的像素尺寸和视图大小的比例，默认情况下它是一个值为 1.0 的浮点数，它其实属于
//    // 支持高分辨率屏幕机制的一部分。如果设置为 1.0，将会以每个点 1 个像素绘制图片；如果设置
//    // 为 2.0，则会以每个点 2 个像素绘制图片，这就是我们熟知的 Retina 屏幕。
//    // 如果 contentsGravity 有拉伸效果，会发现这个属性对展示没有任何影响，因为图片已经被拉伸
//    // 以适应图层的边界。
//    // 当用代码的方式来处理寄宿图的时候，一定要手动的设置此属性，否则，图片在 Retina 设备上就不
//    // 能正确显示。
//    _displayView.layer.contentsScale = image.scale;
//
//    // 此属性允许我们在图层边框里显示寄宿图的一个子域。多张图片可以拼合成一张大图并一次性载入，相
//    // 比多次载入不同的图片，这样做能够带来很多方面的好处：内存使用、载入时间、渲染性能等等。
//    _displayView.layer.contentsRect = CGRectMake(0, 0, 0.3, 0.3);
//
//    // 定义了图层中的可拉伸区域和一个固定的边框
//    _displayView.layer.contentsCenter = CGRectMake(0.25, 0.25, 0.5, 0.5);
  }

//  NSObject *obj = [[NSObject alloc] init];
//  void *p = (__bridge_retained void *)obj;
//  NSLog(@"%p", p);
//  CFRelease(p);

//  NSArray *array = [[NSArray alloc] initWithObjects:@"aaa", @"bbb", @"ccc", nil];
//  CFArrayRef arrayRef = (__bridge_retained CFArrayRef)array;
//  NSLog(@"%ld", (long)CFArrayGetCount(arrayRef));
//  CFRelease(arrayRef);

//  CFStringRef strs[3] = {CFSTR("aaa"), CFSTR("bbb"), CFSTR("ccc")};
//  CFArrayRef arrayRef = CFArrayCreate(NULL, (const void **)strs, 3, &kCFTypeArrayCallBacks);
//  NSArray *array = (__bridge_transfer NSArray *)arrayRef;
//  NSLog(@"%@", array);

  


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

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];

//  XYZWebViewController *wvc = [[XYZWebViewController alloc] initWithURL:@"https://www.baidu.com/"];
//  XYZWebViewController *wvc = [[XYZWebViewController alloc] initWithURL:@"http://kevinsblog.cn/"];
//  [self.navigationController pushViewController:wvc animated:YES];
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
