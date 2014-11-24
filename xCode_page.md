### Ref
- [使用Xcode和Instruments调试解决iOS内存泄露](http://blog.csdn.net/totogo2010/article/details/8233565)
- [xCode5：资源管理，Asset Catalog和Image Slicing，Modules解释](http://onevcat.com/2013/06/new-in-xcode5-and-objc/)

### 选择Xcode版本打包发布App

如何你和我一样手贱安装了Xcode6，同时又需要发布应用到商店时，你会发现打好的包是通不过审核的。验证报错：

    unable to validate application archives of type:0x0

Google报错信息后，发现Beta版的Xcode打的包是不能发布到商店的。这时候即使你启用原来的Xcode5去打包，打出来的包也会报错的。这是因为安装Xcode6Beta以后，本地的命令行工具已经被换成了最新的。

解决的办法如下：通过xcode-select 指定命令行工具版本。

    sudo xcode-select --switch /Applications/Xcode.app
然后使用Xcode5打包即可。

### Themes
```ruby
mkdir -p ~/Library/Developer/Xcode/UserData/FontAndColorThemes;
cd ~/Library/Developer/Xcode/UserData/FontAndColorThemes;
curl -O http://developers.enormego.com/assets/egotheme/EGOv2.dvtcolortheme
curl -O https://github.com/akinsella/xcode-railscasts-theme/blob/master/RailsCast_Inspired.dvtcolortheme
xcode->Perference->Fonts->EGOv2
```

### CocoaPod
> 升级还是安装都是`sudo gem install cocoapods`

### 问题解决 ld: library not found for -lPods 
https://github.com/CocoaPods/CocoaPods/pull/1329#issuecomment-24203327
> closing xcode
deleting the workspace
pod install
Open xcode and accept the option to Update to recommended settings

[[images/xcode-error.png]]

### xcode调用OC header
在PROJECT_NAME_Prefix.pch中加入：
```
#ifdef __OBJC__
    #import <Foundation/Foundation.h>
    #import <UIKit/UIKit.h>
    #import <opencv/cv.h>
#endif
```

### 在发布版本时让NSLog()安静
在发布上线版本时需要关掉所有的log输出，一是听说会影响性能，二来让其他开发者看到也是显的相当不专业。以前项目组中经常中手动一个个关。也有同事试着重写系统的NSLog函数，但是没成功。
今天偶然发现了下面的方法，亲测是没问题的。
在(projectname)_Prefix.pchj里面加上如下代码：

```
#ifndef __OPTIMIZE__
#    define NSLog(...) NSLog(__VA_ARGS__)
#else
#    define NSLog(...) {}
#endif
```
其实差异就是release mode 会将project设定为__OPTIMIZE__,而debug mode并没有这样的设定。。。

--EOF--