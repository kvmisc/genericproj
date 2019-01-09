# genericproj

## 模块说明

* App：仅用于存放 info、main、prefix 和 AppDelegate；
* Pages：所有页面；
* Core：最基础的工具；
* Extentions：公用分类；
* Common：公用显示组件，比如视图、视图控制器等；
* Utils：公用非显示工具，比如网络请求、数据管理等；
* Support：支持工具，比如编译脚本、Podfile 等；
* Resources：资源文件；
* Vendors：存放 cocoapods 没有的库和 cocoapods 已有但需要修改源码的库；
* Docs：参考文档。

每个模块内部都有一个 README.md 文件，模块自身的细节问题和注意事项都可以写到里面。

## Xcode 设置

1. 缩进 2 个字符，且使用空格代替制表符；

2. 勾选 Automatically trim trailing whitespace 和 Including whitespace-only lines 选项；

## 发版注意

1. 每个模块的 README.md 文件、Support 和 Docs 目录下的文件千万不要打包到软件中；

2. 全局搜索 CONFIGURABLE_VALUE，找到所有需要配置的值，然后酌情修改；

## 其它说明

### 版本号

Version 需要在每次发版的时候手动修改，而 Build 则通过脚本自动单调递增，表示编译的次数。自动修改编译号的脚本已添加到 Build Phases -> Bump Build Number。
