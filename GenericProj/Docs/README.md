
## 图片管理

偶尔显示的大图片应放到工程目录，不要放到 Assets.xcassets 中，并使用 `[[UIImage alloc] initWithContentsOfFile:path]` 加载，系统不会缓存这种图片，它会在显示结束后快速释放。

经常显示的小图片放到 Assets.xcassets 中让系统缓存，使用 `[UIImage imageNamed:name]` 加载，这种图片的具体释放时间由系统决定。

Ref: <https://www.jianshu.com/p/ca130b97446b>

## 性能优化

* 将不透明视图的 opaque 属性置为 YES；
* 尽量提前计算好 cell 高度，缓存在相应的数据源模型中，减少 CPU 计算时间；
* 尽量提前计算好布局，在有需要时一次性调整对应的布局，不要多次修改属性；
* Autolayout 会比直接设置 frame 消耗更多的 CPU 资源，但为了加快开发速度、减少适配难度，不是不能用；
* XIB 创建视图会比代码创建视图慢，但也不是不能用；
* 尽量把耗时的操作放到子线程；
* 图片的 size 最好跟 UIImageView 的 size 保持一致；
* 控制线程的最大并发数量；
