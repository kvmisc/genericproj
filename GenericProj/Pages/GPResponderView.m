//
//  GPResponderView.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/3/28.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "GPResponderView.h"

@implementation GPResponderView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [super touchesBegan:touches withEvent:event];
  //[self.nextResponder touchesBegan:touches withEvent:event];
  NSLog(@"responser <%@> touch began", _name);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [super touchesMoved:touches withEvent:event];
  //[self.nextResponder touchesMoved:touches withEvent:event];
  NSLog(@"responser <%@> touch moved", _name);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [super touchesCancelled:touches withEvent:event];
  //[self.nextResponder touchesCancelled:touches withEvent:event];
  NSLog(@"responser <%@> touch cancelled", _name);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [super touchesEnded:touches withEvent:event];
  //[self.nextResponder touchesEnded:touches withEvent:event];
  NSLog(@"responser <%@> touch ended", _name);
}

@end
