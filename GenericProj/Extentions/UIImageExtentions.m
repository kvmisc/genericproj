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


- (UIImage *)tk_roundedCornerImage:(CGFloat)cornerRadius
{
  UIImage *resultImage = nil;

  size_t imageWidth = CGImageGetWidth(self.CGImage);
  size_t imageHeight = CGImageGetHeight(self.CGImage);

  CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();

  if ( colorSpaceRef ) {

    CGContextRef contextRef = CGBitmapContextCreate(NULL, imageWidth, imageHeight, 8, 0, colorSpaceRef, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host);
    if ( contextRef ) {

      CGFloat radius = cornerRadius * self.scale;
      CGFloat minX = 0.0, midX = floor(imageWidth/2.0), maxX = floor(imageWidth);
      CGFloat minY = 0.0, midY = floor(imageHeight/2.0), maxY = floor(imageHeight);

      CGContextBeginPath(contextRef);
      CGContextMoveToPoint(contextRef, minX, midY);
      CGContextAddArcToPoint(contextRef, minX, minY, midX, minY, radius);
      CGContextAddArcToPoint(contextRef, maxX, minY, maxX, midY, radius);
      CGContextAddArcToPoint(contextRef, maxX, maxY, midX, maxY, radius);
      CGContextAddArcToPoint(contextRef, minX, maxY, minX, midY, radius);
      CGContextClosePath(contextRef);
      CGContextClip(contextRef);

      CGContextDrawImage(contextRef, CGRectMake(0.0, 0.0, imageWidth, imageHeight), self.CGImage);

      CGImageRef resultImageRef = CGBitmapContextCreateImage(contextRef);
      if ( resultImageRef ) {
        resultImage = [UIImage imageWithCGImage:resultImageRef scale:self.scale orientation:UIImageOrientationUp];
        CGImageRelease(resultImageRef);
      }
      CGContextRelease(contextRef);
    }
    CGColorSpaceRelease(colorSpaceRef);
  }

  return resultImage;




//  CGFloat scale = self.scale;
//
//  CGRect rect = CGRectMake(0.0, 0.0, scale*self.size.width, scale*self.size.height);
//
//  UIEdgeInsets cornerInset = UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius);
//  cornerInset.topRight *= scale;
//  cornerInset.topLeft *= scale;
//  cornerInset.bottomLeft *= scale;
//  cornerInset.bottomRight *= scale;
//
//
//  CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//  CGContextRef contextRef = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
//  CGColorSpaceRelease(colorSpace);
//
//  if (context == NULL)
//    return nil;
//
//  CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
//  CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
//  CGContextBeginPath(context);
//  CGContextMoveToPoint(context, minx, midy);
//  CGContextAddArcToPoint(context, minx, miny, midx, miny, cornerInset.bottomLeft);
//  CGContextAddArcToPoint(context, maxx, miny, maxx, midy, cornerInset.bottomRight);
//  CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, cornerInset.topRight);
//  CGContextAddArcToPoint(context, minx, maxy, minx, midy, cornerInset.topLeft);
//  CGContextClosePath(context);
//  CGContextClip(context);
//
//  CGContextDrawImage(context, rect, self.CGImage);
//
//  CGImageRef bitmapImageRef = CGBitmapContextCreateImage(context);
//
//  CGContextRelease(context);
//
//  UIImage *newImage = [UIImage imageWithCGImage:bitmapImageRef scale:scale orientation:UIImageOrientationUp];
//
//  CGImageRelease(bitmapImageRef);
//
//  return newImage;
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

+ (UIImage *)tk_decodeImage:(UIImage *)image
{
  UIImage *decodedImage = nil;

  CGImageRef imageRef = image.CGImage;

  // 返回结果的单位是像素，而不是点，所以结果是：
  //   width = image.size.width * image.scale
  //   height = image.size.height * image.scale
  size_t imageWidth = CGImageGetWidth(imageRef);
  size_t imageHeight = CGImageGetHeight(imageRef);
  XYZLog(@"%@ %f, %d, %d", NSStringFromCGSize(image.size), image.scale, (int)imageWidth, (int)imageHeight);

  CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();

  if ( colorSpaceRef ) {

    BOOL opaque = YES;
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    if (alphaInfo == kCGImageAlphaFirst
        || alphaInfo == kCGImageAlphaLast
        || alphaInfo == kCGImageAlphaOnly
        || alphaInfo == kCGImageAlphaPremultipliedFirst
        || alphaInfo == kCGImageAlphaPremultipliedLast)
    {
      opaque = NO;
    }
    CGBitmapInfo bitmapInfo = opaque ?
    (kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Host) :
    (kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host);

    CGContextRef contextRef = CGBitmapContextCreate(NULL, imageWidth, imageHeight, 8, 0, colorSpaceRef, bitmapInfo);
    if ( contextRef ) {

      CGContextDrawImage(contextRef, CGRectMake(0.0, 0.0, imageWidth, imageHeight), imageRef);
      CGImageRef decodedImageRef = CGBitmapContextCreateImage(contextRef);

      if ( decodedImageRef ) {
        decodedImage = [[UIImage alloc] initWithCGImage:decodedImageRef
                                                  scale:image.scale
                                            orientation:image.imageOrientation];
        CGImageRelease(decodedImageRef);
      }
      CGContextRelease(contextRef);
    }
    CGColorSpaceRelease(colorSpaceRef);
  }

  return decodedImage;
}

@end
