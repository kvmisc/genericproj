//
//  NSArrayAdditions.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (TapKit)

///-------------------------------
/// Querying
///-------------------------------

- (id)tk_objectOrNilAtIndex:(NSUInteger)idx;

- (id)tk_randomObject;


- (BOOL)tk_hasObjectEqualTo:(id)object;

- (BOOL)tk_hasObjectIdenticalTo:(id)object;


///-------------------------------
/// Key-Value Coding
///-------------------------------

- (NSArray *)tk_objectsForKeyPath:(NSString *)keyPath equalTo:(id)value;

- (NSArray *)tk_objectsForKeyPath:(NSString *)keyPath identicalTo:(id)value;


- (id)tk_objectForKeyPath:(NSString *)keyPath equalTo:(id)value;

- (id)tk_objectForKeyPath:(NSString *)keyPath identicalTo:(id)value;


- (NSInteger)tk_indexOfObjectForKeyPath:(NSString *)keyPath equalTo:(id)value;

- (NSInteger)tk_indexOfObjectForKeyPath:(NSString *)keyPath identicalTo:(id)value;


- (NSInteger)tk_numberOfObjectsForKeyPath:(NSString *)keyPath equalTo:(id)value;

- (NSInteger)tk_numberOfObjectsForKeyPath:(NSString *)keyPath identicalTo:(id)value;

@end



@interface NSMutableArray (TapKit)

///-------------------------------
/// Content management
///-------------------------------

- (id)tk_addObjectIfNotNil:(id)object;

- (id)tk_addUnequalObjectIfNotNil:(id)object;

- (id)tk_addUnidenticalObjectIfNotNil:(id)object;

- (id)tk_insertObject:(id)object atIndexIfNotNil:(NSUInteger)idx;


///-------------------------------
/// Ordering
///-------------------------------

- (void)tk_shuffle;

- (void)tk_reverse;

- (id)tk_moveObjectAtIndex:(NSUInteger)idx toIndex:(NSUInteger)toIdx;


///-------------------------------
/// Stack operation
///-------------------------------

- (id)tk_push:(id)object;

- (id)tk_pop;


///-------------------------------
/// Queue operation
///-------------------------------

- (id)tk_enqueue:(id)object;

- (id)tk_dequeue;

@end
