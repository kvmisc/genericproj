//
//  NSArrayAdditions.m
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSArrayAdditions.h"
#import "NSObjectAdditions.h"

@implementation NSArray (TapKit)

#pragma mark - Querying

- (id)tk_objectOrNilAtIndex:(NSUInteger)idx
{
  if ( idx<[self count] ) {
    return [self objectAtIndex:idx];
  }
  return nil;
}

- (id)tk_randomObject
{
  if ( [self count]>0 ) {
    NSUInteger idx = arc4random() % [self count];
    return [self objectAtIndex:idx];
  }
  return nil;
}


- (BOOL)tk_hasObjectEqualTo:(id)object
{
  return ( [self indexOfObject:object]!=NSNotFound );
}

- (BOOL)tk_hasObjectIdenticalTo:(id)object
{
  return ( [self indexOfObjectIdenticalTo:object]!=NSNotFound );
}



#pragma mark - Key-Value Coding

- (NSArray *)tk_objectsForKeyPath:(NSString *)keyPath equalTo:(id)value
{
  NSMutableArray *objectAry = [[NSMutableArray alloc] init];

  for ( NSUInteger i=0; i<[self count]; ++i ) {
    id object = [self objectAtIndex:i];
    if ( [object tk_isValueForKeyPath:keyPath equalTo:value] ) {
      [objectAry addObject:object];
    }
  }

  if ( [objectAry count]>0 ) {
    return objectAry;
  }
  return nil;
}

- (NSArray *)tk_objectsForKeyPath:(NSString *)keyPath identicalTo:(id)value
{
  NSMutableArray *objectAry = [[NSMutableArray alloc] init];

  for ( NSUInteger i=0; i<[self count]; ++i ) {
    id object = [self objectAtIndex:i];
    if ( [object tk_isValueForKeyPath:keyPath identicalTo:value] ) {
      [objectAry addObject:object];
    }
  }

  if ( [objectAry count]>0 ) {
    return objectAry;
  }
  return nil;
}


- (id)tk_objectForKeyPath:(NSString *)keyPath equalTo:(id)value
{
  for ( NSUInteger i=0; i<[self count]; ++i ) {
    id object = [self objectAtIndex:i];
    if ( [object tk_isValueForKeyPath:keyPath equalTo:value] ) {
      return object;
    }
  }
  return nil;
}

- (id)tk_objectForKeyPath:(NSString *)keyPath identicalTo:(id)value
{
  for ( NSUInteger i=0; i<[self count]; ++i ) {
    id object = [self objectAtIndex:i];
    if ( [object tk_isValueForKeyPath:keyPath identicalTo:value] ) {
      return object;
    }
  }
  return nil;
}


- (NSInteger)tk_indexOfObjectForKeyPath:(NSString *)keyPath equalTo:(id)value
{
  for ( NSUInteger i=0; i<[self count]; ++i ) {
    id object = [self objectAtIndex:i];
    if ( [object tk_isValueForKeyPath:keyPath equalTo:value] ) {
      return i;
    }
  }
  return NSNotFound;
}

- (NSInteger)tk_indexOfObjectForKeyPath:(NSString *)keyPath identicalTo:(id)value
{
  for ( NSUInteger i=0; i<[self count]; ++i ) {
    id object = [self objectAtIndex:i];
    if ( [object tk_isValueForKeyPath:keyPath identicalTo:value] ) {
      return i;
    }
  }
  return NSNotFound;
}


- (NSInteger)tk_numberOfObjectsForKeyPath:(NSString *)keyPath equalTo:(id)value
{
  NSInteger count = 0;
  for ( NSUInteger i=0; i<[self count]; ++i ) {
    id object = [self objectAtIndex:i];
    if ( [object tk_isValueForKeyPath:keyPath equalTo:value] ) {
      count++;
    }
  }
  return count;
}

- (NSInteger)tk_numberOfObjectsForKeyPath:(NSString *)keyPath identicalTo:(id)value
{
  NSInteger count = 0;
  for ( NSUInteger i=0; i<[self count]; ++i ) {
    id object = [self objectAtIndex:i];
    if ( [object tk_isValueForKeyPath:keyPath identicalTo:value] ) {
      count++;
    }
  }
  return count;
}

@end



@implementation NSMutableArray (TapKit)

#pragma mark - Content management

- (id)tk_addObjectIfNotNil:(id)object
{
  if ( object ) {
    [self addObject:object];
    return object;
  }
  return nil;
}

- (id)tk_addUnequalObjectIfNotNil:(id)object
{
  if ( object ) {
    if ( ![self tk_hasObjectEqualTo:object] ) {
      [self addObject:object];
      return object;
    }
  }
  return nil;
}

- (id)tk_addUnidenticalObjectIfNotNil:(id)object
{
  if ( object ) {
    if ( ![self tk_hasObjectIdenticalTo:object] ) {
      [self addObject:object];
      return object;
    }
  }
  return nil;
}

- (id)tk_insertObject:(id)object atIndexIfNotNil:(NSUInteger)idx
{
  if ( object ) {
    if ( idx<=[self count] ) {
      [self insertObject:object atIndex:idx];
      return object;
    }
  }
  return nil;
}



#pragma mark - Ordering

// http://en.wikipedia.org/wiki/Knuth_shuffle
- (void)tk_shuffle
{
  for ( NSUInteger i=[self count]; i>1; --i ) {

    NSUInteger m = 1;
    do {
      m <<= 1;
    } while ( m<i );

    NSUInteger j = 0;
    do {
      j = arc4random() % m;
    } while ( j>=i );

    [self exchangeObjectAtIndex:(i-1) withObjectAtIndex:j];
  }
}

- (void)tk_reverse
{
  for ( NSUInteger i=0; i<floor([self count]/2.0); ++i ) {
    NSUInteger idx = [self count] - (i+1);
    [self exchangeObjectAtIndex:i withObjectAtIndex:idx];
  }
}

- (id)tk_moveObjectAtIndex:(NSUInteger)idx toIndex:(NSUInteger)toIdx
{
  if ( idx!=toIdx ) {
    if ( (idx<[self count]) && (toIdx<[self count]) ) {
      id object = [self objectAtIndex:idx];
      [self removeObjectAtIndex:idx];
      [self insertObject:object atIndex:toIdx];
      return object;
    }
  }
  return nil;
}



#pragma mark - Stack operation

- (id)tk_push:(id)object
{
  return [self tk_addObjectIfNotNil:object];
}

- (id)tk_pop
{
  id object = [self lastObject];
  [self removeLastObject];
  return object;
}



#pragma mark - Queue operation

- (id)tk_enqueue:(id)object
{
  return [self tk_addObjectIfNotNil:object];
}

- (id)tk_dequeue
{
  id object = [self firstObject];
  if ( [self count]>0 ) {
    [self removeObjectAtIndex:0];
  }
  return object;
}

@end
