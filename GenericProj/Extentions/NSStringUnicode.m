//
//  NSStringUnicode.m
//  GenericProj
//
//  Created by Kevin Wu on 11/17/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import "NSStringUnicode.h"

@implementation NSString (Unicode)

- (NSUInteger)tk_numberOfComposedCharacterSequences
{
  __block NSUInteger length = 0;
  [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                           options:NSStringEnumerationByComposedCharacterSequences
                        usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) { length++; }];
  return length;
}

- (NSUInteger)tk_informalLengthByProductManager
{
  __block NSUInteger length = 0;
  [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                           options:NSStringEnumerationByComposedCharacterSequences
                        usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                          if (substringRange.length>1) {
                            // BMP 以外的字符，算作2个单位
                            length+=2;
                          } else {
                            // BMP 内的字符，当高位字节是0的时候算作1个单位，否则算作2个单
                            // 位
                            unichar chr = [substring characterAtIndex:0];
                            if ( (chr & 0x00ff) == chr ) {
                              length+=1;
                            } else {
                              length+=2;
                            }
                          }
                        }];
  return length;
}


- (NSString *)tk_stringByRemovingLastComposedCharacterSequence
{
  if ( self.length>0 ) {
    NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:[self length]-1];
    return [self substringToIndex:range.location];
  }
  // 空字符串返回本身
  return self;
}

- (NSString *)tk_stringByRemovingFirstComposedCharacterSequence
{
  if ( self.length>0 ) {
    NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:0];
    return [self substringFromIndex:range.length];
  }
  // 空字符串返回本身
  return self;
}

- (NSString *)tk_stringByTruncatingToLength:(NSUInteger)length
{
  if ( self.length>0 ) {
    if ( length<=0 ) {
      return @"";
    }
    if ( [self tk_numberOfComposedCharacterSequences]>length ) {
      NSUInteger idx = 0;
      for ( NSInteger i=0; i<length; ++i ) {
        NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:idx];
        idx += range.length;
      }
      return [self substringToIndex:idx];
    }
  }
  // 空字符串返回本身
  return self;
}


- (BOOL)tk_isCanonicallyEquivalentTo:(NSString *)string
{
  if ( !string ) {
    // 自己不是 nil，string 是 nil，不同
    return NO;
  }

  if ( self.length<=0 ) {
    // 自己是空字符串，判断 string 是否为空即可
    return (string.length<=0);
  }

  // 都不是空字符串，先将它们标准化为 C 形式，再逐字比较
  NSString *str1 = [self precomposedStringWithCanonicalMapping];
  NSString *str2 = [string precomposedStringWithCanonicalMapping];
  return [str1 isEqualToString:str2];
}

- (BOOL)tk_isCompatibilityEquivalentTo:(NSString *)string
{
  if ( !string ) {
    // 自己不是 nil，string 是 nil，不同
    return NO;
  }

  if ( self.length<=0 ) {
    // 自己是空字符串，判断 string 是否为空即可
    return (string.length<=0);
  }

  // 都不是空字符串
  return ([self localizedCompare:string]==NSOrderedSame);
}

@end


@implementation NSMutableString (Unicode)

- (void)tk_removeLastComposedCharacterSequence
{
  if ( self.length>0 ) {
    NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:[self length]-1];
    [self deleteCharactersInRange:range];
  }
}

- (void)tk_removeFirstComposedCharacterSequence
{
  if ( self.length>0 ) {
    NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:0];
    [self deleteCharactersInRange:range];
  }
}

- (void)tk_truncateToLength:(NSUInteger)length
{
  if ( self.length>0 ) {
    if ( length<=0 ) {
      [self deleteCharactersInRange:NSMakeRange(0, [self length])];
    }
    if ( [self tk_numberOfComposedCharacterSequences]>length ) {
      NSUInteger idx = 0;
      for ( NSInteger i=0; i<length; ++i ) {
        NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:idx];
        idx += range.length;
      }
      [self deleteCharactersInRange:NSMakeRange(idx, [self length]-idx)];
    }
  }
}

@end
