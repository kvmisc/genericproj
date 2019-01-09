//
//  GPModel.m
//  GenericProj
//
//  Created by Haiping Wu on 20/01/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "GPModel.h"
#import <MJExtension/MJExtension.h>

@implementation GPModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
  if ( property.type.typeClass == [NSDate class] ) {
    if ( (oldValue) && [oldValue isKindOfClass:[NSDate class]] ) {
      return oldValue;
    } else {
      return [XYZDateFormatter01 dateFromString:oldValue];
    }
  }
  return oldValue;
}

+ (NSDictionary *)objectClassInArray
{
  return @{
           @"optionList":@"XYZOptionModel",
           @"tagList":@"XYZTagModel",
           @"commentList":@"XYZCommentModel"
           };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
  return @{
           @"desc":@"description"
           };
}

@end
