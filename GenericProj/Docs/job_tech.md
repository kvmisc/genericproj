## Objective-C 本质

* OC 的类在底层是 C/C++ 中的结构体类型，NSObject 对象在内存中就是一个结构体对象；
* NSObject 对象只有一个指针变量，64 位系统中指针变量占用 8B 空间，系统为 NSObject 对象分配 16B 内存，OC 是按照 16 的整倍数给实例分配内存的；
* `class_getInstanceSize` 方法获取的是内存对齐后的大小，即占用内存最大成员所需空间的整倍数，`malloc_size` 方法获取的是系统实际分配的内存大小；

## Objective-C 对象

* OC 对象分为三种：实例对象、类对象、元类对象；
* 实例对象包含：isa 指针和成员变量；
* 类对象通过 `- (Class)class`、`+ (Class)class` 或 `Class object_getClass(id obj)` 获取，每个类有且只有一个类对象；
* 类对象主要包含：isa 指针、super_class 指针、成员变量信息、实例方法、协议信息等；
* NSObject 的两个 `class` 方法只能获取类对象，元类对象只能通过 `Class object_getClass(id obj)` 获取，每个类有且只有一个元类对象；
* `Class object_getClass(id obj)` 能接受三种对象作为参数，传实例对象返回类对象，传类对象返回元类对象，传元类对象返回根元类对象；
* 元类对象的数据结构与类对象一样，主要包含：isa 指针、super_class 指针和类方法；

## Runtime

* OC 编译时可以调用任何函数，即使函数不存在，只要有函数声明就行，在运行的时候才决定真正调用哪个函数，而 C 语言在编译时就决定调用哪个函数；
* Runtime 应用：关联对象、方法交换、KVO、NSCoding 自动归档/解档、字典和模型转换、热更新（消息转发）；
* id 是 objc_object 结构体指针，isa 是 Class 类型，Class 是 objc_class 结构体指针；
* Method 是 objc_method 结构体指针，里面包含：方法名（SEL）、方法信息、方法实现（IMP），SEL 是 objc_selector 指针，会被映射为 C 字符串，IMP 是函数指针；
* NSMethodSignature 是一个方法的返回类型和参数类型，不包括方法名称。

## isa 和 super_class

* 实例对象的 isa 指向类对象, 类对象的 isa 指向元类对象，元类对象的 isa 指向最顶层基类的元类对象；
* 类对象的 super_class 指向父类的类对象，NSObject 类对象的 super_class 指向 nil；
* 元类对象的 super_class 指向父类的元类对象，NSObject 元类对象的 super_class 指向 NSObject 类对象；

## KVO

* 给类实例添加 KVO 时，runtime 会动态生成一个子类，并将实例的 isa 指针指向此子类；
* 子类会重载 set 方法并调用父类实现，调用父类实现前后会添加 `willChangeValueForKey:` 和 `didChangeValueForKey:` 调用，由此触发监听器的方法；
* 直接修改成员变量的值并不会触发监听器的方法，因为 `willChangeValueForKey:` 和 `didChangeValueForKey:` 并没被调用；
* 如果要手动触发 KVO，可以手动调用上述两个方法，且必须成对出现；

## KVC

* 添加对属性的 KVO，使用 KVC 给属性赋值时，可以触发 KVO；
* 添加对成员变量的 KVO，使用 KVC 给成员变量赋值时，可以触发 KVO；
* 赋值时的顺序：`setKey:`、`_setKey:`、`accessInstanceVariablesDirectly`、`_key`、`_isKey`、`key`、`isKey`、`setValue:forUndefinedKey:`，否则抛出异常；
* 取值时的顺序：`getKey`、`key`、`isKey`、`_key`、`accessInstanceVariablesDirectly`、`_key`、`_isKey`、`key`、`isKey`、`valueForUndefinedKey:`，否则抛出异常；

## load 和 initialize

### load

* 程序启动时，runtime 会主动调用所有类和分类的 `load` 方法，只调用一次；
* 父类的 `load` 会先于子类的 `load` 被调用；
* 类的 `load` 会先于分类的 `load` 被调用；
* 文件编译顺序决定一个类的两个不同分类的 `load` 调用顺序；
* 文件编译顺序决定两个无继承关系的类的 `load` 调用顺序；
* runtime 会调用所有的 `load` 方法，但代码调用（即 `[xxx load];`）使用的是消息机制，仅会调用最先被找到的方法；
* `load` 方法可以继承，但一般不要主动调用，系统会自动调用；
* 系统底层使用函数指针直接调用 `load` 方法，会调用所有的；

### initialize

* 类第一次接受消息时，系统会调用类的 `initialize` 方法；
* 如果类有父类，且父类未初始化，会优先调用父类的 `initialize` 方法；
* 系统底层通过消息机制调用 `initialize` 方法，仅会调用最先被找到的方法，所以分类中的方法会被调用，而类中的方法不会被调用；
* 如果父类实现 `initialize` 方法，而子类不实现，子类第一次接受消息时，父类先初始化，子类再初始化，由于子类并未实现 `initialize` 方法，所以消息机制会将子类的初始化消息会发到父类，这时父类的 `initialize` 方法会被调用两次；

### 区别

* `load` 是用函数指针直接调用，`initialize` 是通过消息机制调用；
* `load` 是 runtime 加载类和分类时调用，且只调用一次，`initialize` 是类第一次接受消息时调用，如果子类没实现此方法，父类的 `initialize` 方法会被调用多次；

## Category

* 分类被编译后是以结构体的形式表示，并不会被并入类对象和元类对象，runtime 会将分类并入类对象和元类对象；
* 分类结构体包含类名、类、实例方法、类方法、属性和协议信息，系统会生成一个此结构体的静态实例；
* 分类并入类对象和元类对象的时候，后加载的分类会排在前面，如果一个类和它的不同分类都有某同名方法，分类方法会排在类方法前面，后加载的分类方法会排在先加载的分类方法前面，当用消息机制调用方法时，后加载的方法会被调用；
* 类扩展在编译的时候并入类信息中，分类由 runtime 并入类信息中；

## block

* block 被编译后是以结构体的形式表示，代码块会生成一个静态函数，block 结构体包含 isa、函数地址、捕获的变量等信息，block 本质是封装了函数调用以及函数调用环境的 OC 对象；
* 值捕获：当 block 内部使用 auto 变量时，变量的值会在创建 block 时传递给构造函数，并保存在 block 结构体中，block 调用时使用的是保存在结构体中的变量的值；
* 指针捕获：当 block 内部使用静态变量时，变量的指针会在创建 block 时传递给构造函数，并保存在 block 结构体中，block 调用时会通过指针取到最新的变量的值；
* 不捕获：当 block 内部使用全局变量时，因为代码块函数和全局变量在相同的作用域，函数能够直接访问变量，所以全局变量并不会捕获到 block 结构体中，创建 block 时也不用传递此参数；
* block 分为三种类型：GlobalBlock、StackBlock、MallocBlock；
* MRC 情况下，不使用 auto 变量是全局，使用 auto 变量是栈，栈 copy 以后在堆，全局 copy 无效果，堆 copy 引用计数加 1；
* 在 MRC 的基础上， 开启 ARC 时编译器会自动根据情况将栈复制到堆：栈作为函数返回值时、强指针指向栈时、作为 usingBlock 类函数参数时、作为 GCD 参数时；
* 全局类型不管怎样都不会变，依然在数据区；
* 栈不会将 auto 对象 retain，栈复制到堆才会 retain，堆释放的时候会对其中 retain 的 auto 对象进行一次 release；
* `__block` 不能修饰全局变量和静态变量, 只能修饰 auto 变量，被修饰的变量会被包装成对象；

## 消息机制

* 动态解析，开发者可以实现 `resolveInstanceMethod:` 和 `resolveClassMethod:` 来动态添加方法实现，动态解析后会重新走消息发送流程；
* 消息转发 - 快速转发，开发者可以实现 `forwardingTargetForSelector:` 方法, 此方法返回一个实例对象，这样可以把消息转发给这个实例对象；
* 消息转发 - 完整转发，如果快速转发没有实现，开发者可以实现 `methodSignatureForSelector:` 在此方法中设置好方法编码后，就会调用 `forwardInvocation:` 方法，在这里可以修改消息接收者, 并调用方法；

## super

* 消息的接收者是 self，而不是父类对象；
* 通过消息机制查找方法的起点是父类，而不是本身的类对象；

## isKindOfClass 和 isMemberOfClass

### 判断类或子类类型

* `- (BOOL)isKindOfClass:(Class)cls` 比较接收者的类对象-父类对象-...-根类对象-nil；
* `+ (BOOL)isKindOfClass:(Class)cls` 比较接收者的元类对象-父元类对象-...-根元类对象-根类对象-nil;

### 判断类确切类型

* `- (BOOL)isMemberOfClass:(Class)cls` 比较接收者的类对象；
* `+ (BOOL)isMemberOfClass:(Class)cls` 比较接收者的元类对象；

## Runloop

* Runloop 保持程序持续运行，分发各种事件（触摸事件、定时器事件），节省 CPU 资源（该做事时做事，没事做时休息）；
* 每个线程都有唯一一个与之对应的 Runloop 对象；
* Runloop 保存在一个全局字典中，线程作为 Key，Runloop 作为 value；
* 线程创建的时候并没有 Runloop 对象，第一次获取 Runloop 时创建 Runloop 对象；
* 线程结束时会销毁与之对应的 Runloop 对象；
* 主线程的 Runloop 已经自动获取并创建，子线程默认没有开启 Runloop；
* NSTimer 依赖于 Runloop，如果 Runloop 任务过于繁重，会导致 NSTimer 不准时，GCD 定时器不依赖于 Runloop，会比 NSTimer 更加准时；
* 主线程的 Runloop 会注册两个 observer，观察 Runloop 的状态来创建和删除 AutoreleasePool。

## 多线程

* 自旋锁（OSSpinLock），等待锁的线程会处于忙等（busy-waiting）状态，一直占用着 CPU 资源，OSSpinLock 已不再安全；
* os_unfair_lock 用于取代已不再安全的 OSSpinLock，等待锁的线程会处于休眠状态, 并非忙等；
* pthread_mutex 也叫互斥锁，等待锁的线程会处于休眠状态；
* 递归锁允许一个线程对同一把锁进行重复加锁；
* NSLock、NSRecursiveLock、NSCondition、NSConditionLock 是基于 pthread 封装的 OC 对象，NSConditionLock 是对 NSCondition 的进一步封装；
* @synchronized 是对递归锁的封装，@synchronized(obj) 内部会生成 obj 对应的递归锁，然后进行加锁、解锁操作；
* 性能排行：
  * os_unfair_lock
  * OSSpinLock
  * dispatch_semaphore
  * pthread_mutex
  * dispatch_queue(DISPATCH_QUEUE_SERIAL)
  * NSLock
  * NSCondition
  * pthread_mutex(recursive)
  * NSRecursiveLock
  * NSConditionLock
  * @synchronized
* 使用自旋锁的情况：预计线程等待时间很短；多核处理器；临界区经常被访问但竞争很少发生；CPU 资源不紧张；
* 使用互斥锁的情况：预计线程等待时间较长；单核处理器；临界区有 I/O 操作；临界区代码复杂或循环量大；临界区竞争非常激烈；
* atomic 只能保证 getter 和 setter 内部区域是安全的, 但是外部使用无法保证；
* 读写问题可以用读写锁（pthread_rwlock）和异步栅栏（dispatch_barrier_async）来解决；

## 冒泡排序

将大的数字往后放，外循环 i=len-1 次，内循环 j=len-1-i 次。

~~~
void bubble_sort(int arr[], int len) {
  for ( int i=0; i<len-1; i++ ) {
    for ( int j=0; j<len-1-i; j++ ) {
      if ( arr[j]>arr[j+1] ) {
        int temp = arr[j];
        arr[j] = arr[j+1];
        arr[j+1] = temp;
      }
    }
  }
}
~~~

## 其它

* hash 方法只在对象被添加至 NSSet 和设置为 NSDictionary 的 key 时会调用；

## 设计模式

适配器模式、责任链、原型、代理、观察者、迭代器


* block 被编译后是以结构体的形式表示，代码块会生成一个静态函数，block 结构体包含 isa、函数地址、捕获的变量等信息，block 本质是封装了函数调用以及函数调用环境的 OC 对象；
* ...

* 分类被编译后是以结构体的形式表示，并不会被并入类对象和元类对象，runtime 会将分类并入类对象和元类对象；

* Runtime 应用：关联对象、方法交换、KVO、NSCoding 自动归档/解档、字典和模型转换、热更新（消息转发）；
* Runloop 保存在一个全局字典中，线程作为 Key，Runloop 作为 value；
* 读写问题可以用读写锁（pthread_rwlock）和异步栅栏（dispatch_barrier_async）来解决；
* hash 方法只在对象被添加至 NSSet 和设置为 NSDictionary 的 key 时会调用；
