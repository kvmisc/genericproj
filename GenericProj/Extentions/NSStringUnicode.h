//
//  NSStringUnicode.h
//  GenericProj
//
//  Created by Kevin Wu on 11/17/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/*******************************************************************************

 标准等价(canonically equivalent)，"é" 可以用一个(U+00E9)或两个(U+0065 U+0301)码点表示，
 "가" 可以用一个(U+AC00)或两个(U+1100 U+1161)码点表示。在 Unicode 的语境下，这两种形式并不
 相等(因为两种形式包含不同的码点)，但是符合标准等价，也就是说，码点不同但外观和意义相同。

 相容等价(compatibility equivalence)，"ﬀ" 可以用一个(U+FB00)或两个(U+0066 U+0066)码点
 表示，罗马数字和阿拉伯数字用不同的码点表示，这些字符符合相容等价，也就是说，码点和外观不同但意义相
 同。

 //https://www.objc.io/issues/9-strings/unicode/#peculiar-unicode-features
 //https://zhuanlan.zhihu.com/p/19687727?columnSlug=cbbcd

 ******************************************************************************/

@interface NSString (Unicode)

- (NSUInteger)tk_numberOfComposedCharacterSequences;
// 占位1个字节的字符算1个单位，占位2个及以上字节的字符都算2个单位。ASCII 码和汉字都属于 BMP，可
// 以用 unichar 表示，但 emoji 不属于 BMP，一个 unichar 装不下。
- (NSUInteger)tk_informalLengthByProductManager;

// 空字符串直接返回本身
- (NSString *)tk_stringByRemovingLastComposedCharacterSequence;
- (NSString *)tk_stringByRemovingFirstComposedCharacterSequence;
- (NSString *)tk_stringByTruncatingToLength:(NSUInteger)length;

- (BOOL)tk_isCanonicallyEquivalentTo:(NSString *)string;
- (BOOL)tk_isCompatibilityEquivalentTo:(NSString *)string;

@end


@interface NSMutableString (Unicode)

- (void)tk_removeLastComposedCharacterSequence;
- (void)tk_removeFirstComposedCharacterSequence;
- (void)tk_truncateToLength:(NSUInteger)length;

@end
