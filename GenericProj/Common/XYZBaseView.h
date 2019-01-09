//
//  XYZBaseView.h
//  GenericProj
//
//  Created by Kevin Wu on 8/12/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/*******************************************************************************

 Description:
 
 视图的实现包括头文件、源文件和 XIB 文件，其中 XIB 文件不是必需。
 
 1. 以 [[xxx alloc] initWithFrame:yyy]; 的方式使用视图；
    XIB 文件将不会起任何作用，initWithFrame: 方法会调用 setup 方法，应该在
    setup 方法中构建视图。

 2. 在另一个 XIB 文件中使用此视图；
    XIB 文件将不会起任何作用，initWithCoder: 方法会被调用，initWithCoder: 方法会调用 
    setup 方法，应该在 setup 方法中构建视图，然后在 awakeFromNib 方法中进行后
    续的操作。

 3. 以 [xxx loadFromNib]; 的方式使用视图；
    XIB 文件中构建的视图会被加载，initWithCoder: 方法会被调用，initWithCoder: 方法会调用 
    setup 方法，应该在 setup 方法中构建视图，然后在 awakeFromNib 方法中进行后
    续的操作。
 
 全局通用视图应该用头文件和源文件来实现，且满足 [1,2] 使用方式。这样的视图可以在代码中使用，也
 可以在某个 XIB 文件中使用。
 
 局部特殊视图应该用头文件、源文件和 XIB 文件来实现，且满足 [3] 使用方式。这种视图一般比较复杂，
 如果在 setup 方法中用代码创建会比较麻烦。
 

 使用 XIB 文件的情况下，1)如果视图的约束不需要更新，可以在 XIB 文件中设置好；2)如果需要根据不
 同的情况改变约束，则不能在 XIB 中添加约束，应该在 XIB 加载完成后的 awakeFromNib 方法中使用
 Masonry 添加约束，因为 XIB 文件添加的约束不能被 Masonry 更新。


 Ref: https://github.com/PureLayout/PureLayout/wiki/Tips-and-Tricks

 If you're adding constraints from within a UIView subclass, you should override 
 the -[UIView updateConstraints] method. If you're adding constraints from 
 within a UIViewController subclass, you override the 
 -[UIViewController updateViewConstraints] method. You must call super from 
 both, and you should call super at the very end of your implementation. (You 
 may get a runtime crash if you call super before you change constraints on the 
 view.)

 
 Ref: http://stackoverflow.com/questions/20609206/setneedslayout-vs-setneedsupdateconstraints-and-layoutifneeded-vs-updateconstra
 1) If you manipulated constraints directly, call setNeedsLayout.
 2) If you changed some conditions (like offsets or smth) which would change 
    constraints in your overridden updateConstraints method (a recommended way 
    to change constraints, btw), call setNeedsUpdateConstraints, and most of the 
    time, setNeedsLayout after that.
 3) If you need any of the actions above to have immediate effect—e.g. when your 
    need to learn new frame height after a layout pass—append it with a 
    layoutIfNeeded.

 ******************************************************************************/

@interface XYZBaseView : UIView

- (void)setup;

- (void)awakeFromNib;

- (void)updateConstraints;

@end
