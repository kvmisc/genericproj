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

// https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
//
// 4/4s         {320, 480}  {640, 960}    2.0   2.0 image-320w@2x.png image-480h@2x.png
// 5/5s/SE      {320, 568}  {640, 1136}   2.0   2.0 image-320w@2x.png image-568h@2x.png
// 6 /6s /7 /8  {375, 667}  {750, 1334}   2.0   2.0 image-375w@2x.png image-667h@2x.png
// 6P/6sP/7P/8P {414, 736}  {1242, 2208}  3.0   3.0 image-414w@3x.png image-736h@3x.png
// XR           {375, 812}  {750, 1624}   2.0   2.0 image-375w@2x.png image-812h@2x.png
// X/XS/XSM     {375, 812}  {1125, 2436}  3.0   3.0 image-375w@3x.png image-812h@3x.png
+ (UIImage *)tk_screenWImageNamed:(NSString *)name;
+ (UIImage *)tk_screenHImageNamed:(NSString *)name;


+ (UIImage *)tk_imageWithColor:(UIColor *)color size:(CGSize)size;


+ (UIImage *)tk_decodedImageWithImage:(UIImage *)image;

@end
