//
//  UIImageExtentions.h
//  GenericProj
//
//  Created by Haiping Wu on 28/02/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extentions)

- (UIImage *)tk_scaleToAspectFit:(CGSize)boundSize obligatory:(BOOL)obligatory;

- (UIImage *)tk_scaleToAspectFill:(CGSize)boundSize obligatory:(BOOL)obligatory;

- (UIImage *)tk_scaleToFill:(CGSize)boundSize obligatory:(BOOL)obligatory;


- (UIImage *)tk_roundedCornerImage:(CGFloat)cornerRadius;


// https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
//
// 4/4s         {320, 480}  {640, 960}    2.0   2.0 image-320w@2x.png image-480h@2x.png
// 5/5s/SE      {320, 568}  {640, 1136}   2.0   2.0 image-320w@2x.png image-568h@2x.png
// 6 /6s /7 /8  {375, 667}  {750, 1334}   2.0   2.0 image-375w@2x.png image-667h@2x.png
// 6P/6sP/7P/8P {414, 736}  {1242, 2208}  3.0   3.0 image-414w@3x.png image-736h@3x.png
// X/XS         {375, 812}  {1125, 2436}  3.0   3.0 image-375w@3x.png image-812h@3x.png
// XR           {414, 896}  {828, 1792}   2.0   2.0 image-414w@2x.png image-896h@2x.png
// XSM          {414, 896}  {1242, 2688}  3.0   3.0 image-414w@3x.png image-896h@3x.png
+ (UIImage *)tk_screenWImageNamed:(NSString *)name;
+ (UIImage *)tk_screenHImageNamed:(NSString *)name;


+ (UIImage *)tk_imageWithColor:(UIColor *)color size:(CGSize)size;


// 无论传入图片 scale 是什么，画图片都是用像素值，最后根据原始图片的 scale 来决定最终图片的 size 和 scale
//
// cover@2x.png, size in pixel: 512*512
//
// UIImage *image1 = [UIImage imageNamed:@"cover"];
//   size:256*256, scale:2.0
//
// UIImage *image2 = [UIImage pin_decodedImageWithCGImageRef:image1.CGImage];
//   size:512*512, scale:1.0
//
// UIImage *image3 = [UIImage tk_decodeImage:image1];
//   size:256*256, scale:2.0
+ (UIImage *)tk_decodeImage:(UIImage *)image;

@end
