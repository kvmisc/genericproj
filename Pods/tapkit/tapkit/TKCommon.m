//
//  TKCommon.m
//  TapKit
//
//  Created by Kevin on 5/21/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKCommon.h"

#pragma mark - System message

void TKPresentSystemMessage(NSString *message)
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
  [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];

  UIViewController *top = [[[UIApplication sharedApplication] keyWindow] rootViewController];
  while ( top.presentedViewController ) { top = top.presentedViewController; }

  [top presentViewController:alertController animated:YES completion:NULL];
}



#pragma mark - Archive object

BOOL TKSaveArchivableObject(id object, NSString *path)
{
  if ( path.length>0 ) {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [data writeToFile:path atomically:YES];
  }
  return NO;
}

id TKLoadArchivableObject(NSString *path)
{
  if ( path.length>0 ) {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
  }
  return nil;
}



#pragma mark - System paths

NSString *TKPathForBundleResource(NSBundle *bundle, NSString *relativePath)
{
  return [[bundle?:[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:relativePath];
}

NSString *TKPathForDocumentResource(NSString *relativePath)
{
  static NSString *DocumentPath = nil;
  if ( DocumentPath.length<=0 ) {
    NSArray *pathAry = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    DocumentPath = [pathAry objectAtIndex:0];
  }
  return [DocumentPath stringByAppendingPathComponent:relativePath];
}

NSString *TKPathForLibraryResource(NSString *relativePath)
{
  static NSString *LibraryPath = nil;
  if ( LibraryPath.length<=0 ) {
    NSArray *pathAry = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    LibraryPath = [pathAry objectAtIndex:0];
  }
  return [LibraryPath stringByAppendingPathComponent:relativePath];
}

NSString *TKPathForCachesResource(NSString *relativePath)
{
  static NSString *CachesPath = nil;
  if ( CachesPath.length<=0 ) {
    NSArray *pathAry = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    CachesPath = [pathAry objectAtIndex:0];
  }
  return [CachesPath stringByAppendingPathComponent:relativePath];
}


BOOL TKCreateDirectory(NSString *path)
{
  if ( path.length>0 ) {
    BOOL isDirectory = NO;
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] ) {
      return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:NULL];
    }
    return isDirectory;
  }
  return NO;
}

BOOL TKDeleteFileOrDirectory(NSString *path)
{
  if ( path.length>0 ) {
    return [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
  }
  return NO;
}
