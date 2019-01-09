//
//  NSObjectExtentions.m
//  GenericProj
//
//  Created by Kevin Wu on 9/8/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "NSObjectExtentions.h"
#import <objc/runtime.h>

@implementation NSObject (Extentions)

- (id)tk_theInfo
{
  return objc_getAssociatedObject(self, @selector(tk_theInfo));
}

- (void)setTk_theInfo:(id)theInfo
{
  objc_setAssociatedObject(self, @selector(tk_theInfo), theInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)tk_encoding:(NSCoder *)coder
{
  for ( NSString *key in [[self class] tk_propertyNames] ) {
    id value = [self valueForKey:key];
    [coder encodeObject:value forKey:key];
  }
}

- (void)tk_decoding:(NSCoder *)coder
{
  for ( NSString *key in [[self class] tk_propertyNames] ) {
    id value = [coder decodeObjectForKey:key];
    [self setValue:value forKey:key];
  }
}

+ (NSArray *)tk_propertyNames
{
  NSArray *nameAry = objc_getAssociatedObject(self, @selector(tk_propertyNames));

  if ( !nameAry ) {

    nameAry = [[NSMutableArray alloc] init];

    Class cls = [self class];
    while ( cls!=[NSObject class] ) {
      unsigned int count = 0;
      objc_property_t *properties = class_copyPropertyList(cls, &count);
      for ( int i=0; i<count; ++i ) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        [(NSMutableArray *)nameAry addObject:@(name)];
      }
      free(properties);
      cls = [cls superclass];
    }

    objc_setAssociatedObject(self, @selector(tk_propertyNames), nameAry, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }

  return nameAry;
}

@end
