
## 图片管理

偶尔显示的大图片应放到工程目录，不要放到 Assets.xcassets 中，并使用 `[[UIImage alloc] initWithContentsOfFile:path]` 加载，系统不会缓存这种图片，它会在显示结束后快速释放。

经常显示的小图片放到 Assets.xcassets 中让系统缓存，使用 `[UIImage imageNamed:name]` 加载，这种图片的具体释放时间由系统决定。

参考：[Bundle 和 xcassets 的主要区别](https://www.jianshu.com/p/ca130b97446b "")

## 性能优化

* 将图片解码工作放到后台执行；
* 将不透明视图的 opaque 属性置为 YES；
* 尽量提前计算 cell 高度，缓存在相应的数据模型中，最好连 cell 内部的布局也算好；
* 尽量提前计算布局，在有需要时一次性调整对应的布局，不要多次修改属性；
* Auto Layout 耗时比传统布局多十几倍，出现卡顿的页面可以考虑使用手动布局；
* XIB 比代码更耗性能，但也不是不能用；
* 应当尽量减少视图数量和层次，如果视图结构过于复杂，混合过程会消耗很多 GPU 资源；
* 图片大小最好跟 UIImageView 大小一致，使用 CGRectIntegral 进行像素对齐，此函数会将 origin 向下取整，size 向上取整；
* 用不到事件处理的地方，可以考虑使用 CALayer 取代 UIView；
* 应尽量避免出现离屏渲染；
* 如果不是导航应用，尽量不要实时更新位置，定位完毕应该关掉定位服务；
* 尽量把耗时的操作放到子线程；
* 控制线程的最大并发数量；

参考：[iOS 的离屏渲染](https://imlifengfeng.github.io/article/593/ "")  

## init 点语法

不要在 init 方法中用点语法访问成员变量，因为子类可能重载 setter，创建子类的时候，父类使用点语法访问的是子类的方法。

~~~
@interface GPPerson : NSObject
@property (nonatomic, copy) NSString *name;
@end
@implementation GPPerson
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.name = @"";
  }
  return self;
}
@end

@interface GPStudent : GPPerson
@end
@implementation GPStudent
- (void)setName:(NSString *)name
{
  [super setName:@"xxx"];
}
@end

GPStudent *student = [[GPStudent alloc] init];
NSLog(@"%@", student.name); // 打印 xxx，但 student 根本没设置名字。
~~~

## ARC 桥

  * `-fobjc-arc`
  * `-fno-objc-arc`

`__bridge` 可以实现 OC 对象与 CoreFoundation 对象之间的互相转换，转换不会改变对象的持有情况。

~~~
// CF->OC，内存泄漏，并未改变对象持有情况，arrayRef 应负责释放
CFStringRef strs[3] = {CFSTR("aaa"), CFSTR("bbb"), CFSTR("ccc")};
CFArrayRef arrayRef = CFArrayCreate(NULL, (const void **)strs, 3, &kCFTypeArrayCallBacks);
NSArray *array = (__bridge NSArray *)arrayRef;
NSLog(@"%@", array);

OC->CF，内存不泄漏，并未改变对象持有情况，array 会被 ARC 释放
NSArray *array = [[NSArray alloc] initWithObjects:@"aaa", @"bbb", @"ccc", nil];
CFArrayRef arrayRef = (__bridge CFArrayRef)array;
NSLog(@"%ld", (long)CFArrayGetCount(arrayRef));
~~~

`__bridge_retained` 用于将 OC 变量转换为 CoreFoundation 对象，赋值完成以后，ARC 将不再管理此对象。

~~~
// OC->CF，无内存泄漏，ARC 已不再管理此对象，不会帮助释放，CF 负责释放
NSArray *array = [[NSArray alloc] initWithObjects:@"aaa", @"bbb", @"ccc", nil];
CFArrayRef arrayRef = (__bridge_retained CFArrayRef)array;
NSLog(@"%ld", (long)CFArrayGetCount(arrayRef));
CFRelease(arrayRef);
~~~

`__bridge_transfer` 用于将 CoreFoundation 对象转换为 OC 对象，赋值完成以后，ARC 将接手管理此对象。

~~~
// CF->OC，无内存泄漏，CF 所创建对象的管理权已经转交给 ARC，不需要 CF 做释放操作
CFStringRef strs[3] = {CFSTR("aaa"), CFSTR("bbb"), CFSTR("ccc")};
CFArrayRef arrayRef = CFArrayCreate(NULL, (const void **)strs, 3, &kCFTypeArrayCallBacks);
NSArray *array = (__bridge_transfer NSArray *)arrayRef;
NSLog(@"%@", array);
~~~
