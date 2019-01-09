//
//  GPImageViewController.m
//  GenericProj
//
//  Created by Haiping Wu on 28/02/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "GPImageViewController.h"

@implementation GPImageViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

//  UIImage *image = [UIImage imageNamed:@"hh.png"];
//  //_imageView.image = [image tk_scaleToAspectFit:CGSizeMake(100.0, 100.0) obligatory:YES];
//  //_imageView.image = [image tk_scaleToAspectFill:CGSizeMake(200.0, 200.0) obligatory:NO];
//  _imageView.image = [image tk_scaleToFill:CGSizeMake(200.0, 200.0) obligatory:NO];

  NSMutableArray *imageAry = [[NSMutableArray alloc] init];

  for ( NSUInteger i=0; i<30; ++i ) {
    UIImageView *iv = [[UIImageView alloc] init];
    [_scrollView addSubview:iv];
    iv.frame = CGRectMake(0.0, i*210.0+10.0, 320.0, 200.0);
    iv.backgroundColor = [UIColor lightGrayColor];
    [imageAry addObject:iv];
  }
  _imageAry = imageAry;

  _scrollView.contentSize = CGSizeMake(320.0, 30*210.0+10.0);

  [_button1 addTarget:self action:@selector(doit1:) forControlEvents:UIControlEventTouchUpInside];
  [_button2 addTarget:self action:@selector(doit2:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)doit1:(id)sender
{
//  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//    for ( NSUInteger i=0; i<30; ++i ) {
//      NSString *str = [NSString stringWithFormat:@"%02d.jpg", (int)(i+1)];
//      UIImage *image = [UIImage imageNamed:str];
//      //UIImage *result = image;
//      UIImage *result = [UIImage tk_decodedImageWithImage:image];
//      //UIImage *result = [UIImage pin_decodedImageWithCGImageRef:image.CGImage];
//      NSLog(@"%@ %f %@ %f", NSStringFromCGSize(image.size), image.scale,
//            NSStringFromCGSize(result.size), result.scale);
//      dispatch_async(dispatch_get_main_queue(), ^{
//        UIImageView *iv = [_imageAry objectAtIndex:i];
//        iv.image = result;
//      });
//    }
//  });

//  double then = CFAbsoluteTimeGetCurrent();
//  for ( NSUInteger i=0; i<30; ++i ) {
//    NSString *str = [NSString stringWithFormat:@"%02d.jpg", (int)(i+1)];
//    //NSLog(@"%@", str);
//    UIImageView *iv = [_imageAry objectAtIndex:i];
//    iv.image = [UIImage imageNamed:str];
//  }
//  double now = CFAbsoluteTimeGetCurrent();
//  printf("NSLock: %f sec\n", now-then);
}

- (void)doit2:(id)sender
{
  NSLog(@"hehe");
}

@end
