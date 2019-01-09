//
//  UIImageExtentions.m
//  GenericProj
//
//  Created by Haiping Wu on 28/02/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "UIImageExtentions.h"

@implementation UIImage (Extentions)

- (UIImage *)tk_scaleToAspectFit:(CGSize)boundSize obligatory:(BOOL)obligatory
{
  CGFloat width = self.size.width;
  CGFloat height = self.size.height;
  if ( (obligatory) || ((width>boundSize.width)||(height>boundSize.height)) ) {
    CGFloat ratioWidth = boundSize.width / width;
    CGFloat ratioHeight = boundSize.height / height;
    CGFloat ratioMin = MIN(ratioWidth, ratioHeight);

    CGSize scaledSize = CGSizeMake(ratioMin*width, ratioMin*height);

    return [self tk_scaleTo:scaledSize viewport:scaledSize];
  }
  return self;
}

- (UIImage *)tk_scaleToAspectFill:(CGSize)boundSize obligatory:(BOOL)obligatory
{
  CGFloat width = self.size.width;
  CGFloat height = self.size.height;
  if ( (obligatory) || ((width>boundSize.width)||(height>boundSize.height)) ) {
    CGFloat ratioWidth = boundSize.width / width;
    CGFloat ratioHeight = boundSize.height / height;
    CGFloat ratioMax = MAX(ratioWidth, ratioHeight);

    return [self tk_scaleTo:CGSizeMake(ratioMax*width, ratioMax*height)
                   viewport:CGSizeMake(floor(boundSize.width), floor(boundSize.height))];
  }
  return self;
}

- (UIImage *)tk_scaleToFill:(CGSize)boundSize obligatory:(BOOL)obligatory
{
  CGFloat width = self.size.width;
  CGFloat height = self.size.height;
  if ( (obligatory) || ((width>boundSize.width)||(height>boundSize.height)) ) {
    return [self tk_scaleTo:boundSize viewport:boundSize];
  }
  return self;
}


- (UIImage *)tk_scaleTo:(CGSize)boundSize viewport:(CGSize)viewportSize
{
  CGSize bound = CGSizeMake(floor(boundSize.width), floor(boundSize.height));
  CGSize viewport = CGSizeMake(floor(viewportSize.width), floor(viewportSize.height));

  UIGraphicsBeginImageContextWithOptions(viewport, NO, 0);
  CGRect rect = CGRectMake(floor((viewport.width-bound.width)/2.0),
                           floor((viewport.height-bound.height)/2.0),
                           bound.width,
                           bound.height);
  [self drawInRect:rect];
  UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return scaledImage;
}


+ (UIImage *)tk_screenWImageNamed:(NSString *)name
{
  NSString *imageName = [name stringByAppendingFormat:@"-%dw", (int)XYZ_SCREEN_WID];
  return [UIImage imageNamed:imageName];
}
+ (UIImage *)tk_screenHImageNamed:(NSString *)name
{
  NSString *imageName = [name stringByAppendingFormat:@"-%dh", (int)XYZ_SCREEN_HET];
  return [UIImage imageNamed:imageName];
}

+ (UIImage *)tk_imageWithColor:(UIColor *)color size:(CGSize)size
{
  CGRect bounds = CGRectMake(0.0, 0.0, floor(size.width), floor(size.height));
  UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0);
  [color setFill];
  UIRectFill(bounds);
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

+ (UIImage *)tk_decodedImageWithImage:(UIImage *)image
{
  CGImageRef imageRef = image.CGImage;
  // System only supports RGB, set explicitly and prevent context error
  // if the downloaded image is not the supported format
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

  CGContextRef contextRef = CGBitmapContextCreate(NULL,
                                               CGImageGetWidth(imageRef),
                                               CGImageGetHeight(imageRef),
                                               8,
                                               // width * 4 will be enough because are in ARGB format, don't read from the image
                                               CGImageGetWidth(imageRef) * 4,
                                               colorSpace,
                                               // kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little
                                               // makes system don't need to do extra conversion when displayed.
                                               kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
  CGColorSpaceRelease(colorSpace);

  if ( !contextRef ) { return nil; }

  CGRect rect = CGRectMake(0.0, 0.0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
  CGContextDrawImage(contextRef, rect, imageRef);
  CGImageRef decodedImageRef = CGBitmapContextCreateImage(contextRef);
  CGContextRelease(contextRef);

  UIImage *decodedImage = [[UIImage alloc] initWithCGImage:decodedImageRef
                                                          scale:image.scale
                                                    orientation:image.imageOrientation];
  CGImageRelease(decodedImageRef);
  return decodedImage;
}

@end
