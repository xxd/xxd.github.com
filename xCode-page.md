####xcode & cocoapod & AppID user guide

#####Themes
```shell
mkdir -p ~/Library/Developer/Xcode/UserData/FontAndColorThemes;
cd ~/Library/Developer/Xcode/UserData/FontAndColorThemes;
curl -O http://developers.enormego.com/assets/egotheme/EGOv2.dvtcolortheme
curl -O https://github.com/akinsella/xcode-railscasts-theme/blob/master/RailsCast_Inspired.dvtcolortheme
xcode->Perference->Fonts->EGOv2
```
-----
#####CocoaPod
> 升级还是安装都是`sudo gem install cocoapods`

-----
##### 问题解决 ld: library not found for -lPods 
https://github.com/CocoaPods/CocoaPods/pull/1329#issuecomment-24203327
> closing xcode
deleting the workspace
pod install
Open xcode and accept the option to Update to recommended settings

[[images/xcode-error.png]]
-----
#####xcode调用OC header
在PROJECT_NAME_Prefix.pch中加入：
``` C
#ifdef __OBJC__
    #import <Foundation/Foundation.h>
    #import <UIKit/UIKit.h>
    #import <opencv/cv.h>
#endif
```
-----
#####在发布版本时让NSLog()安静
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

-----