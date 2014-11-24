教程
- [iOS8 Day-by-Day](http://www.shinobicontrols.com/blog/posts/2014/07/16/ios8-day-by-day-index)
- [iOS7 Day-by-Day](http://www.shinobicontrols.com/blog/posts/2013/09/19/introducing-ios7-day-by-day/)

### 常用代码
1. 17个常用代码整理 http://www.cocoachina.com/newbie/tutorial/2012/1220/5377.html
2. iOS开发：小技巧积累 http://www.cocoachina.com/newbie/tutorial/2012/1016/4928.html
3. iphone开发笔记和技巧总结 http://www.cocoachina.com/bbs/read.php?tid=73570&uid=39045&page=3
4. Iphone开发得一些案例及常用知识 http://www.udroid.cn/bbs/thread-1862-1-1.html
5. iphone开发笔记（updated+20111105）http://blog.csdn.net/linzhiji/article/details/6841556
6. iphone开发几个知识点总结 http://blog.sina.com.cn/s/blog_7daf0a5f0100wo8n.html

### 面试
- 一些iOS面试的高级题目
- [ios面试题收集一（附基本答案）](http://blog.csdn.net/nono_love_lilith/article/details/7873042)
- [iOS面试题搜集(持续更新)](http://blog.csdn.net/iukey/article/details/7590557)
- [腾讯iPhone面试题（转）](http://blog.csdn.net/totogo2010/article/details/6321915)

源码
- [Path 4.0的弹出菜单--DCPathButton](http://code.cocoachina.com/detail/232180)
- [PDF文件浏览和阅读--Reader](http://code.cocoachina.com/detail/232162)
- [ActionSheetPicker-3.0](http://code.cocoachina.com/detail/232178)
- ios之音频转换：amr转换wav（安卓amr是常用格式，wav是ios格式）
    * http://code4app.com/ios/边录音边转码/521c65d56803fab864000001
    * VoiceConverter 第三方库
```
#import "VoiceConverter.h"第三方库

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *videopath=@""; //文件的路径
    NSString *laocationgPath=@""; //转换后保存的路径
   
   // 音频转换
    [VoiceConverter wavToAmr:videopath amrSavePath:laocationgPath];
    [VoiceConverter amrToWav:videopath wavSavePath:laocationgPath];
}
```

### iOS7适配
```ruby
//用于ios7下有关位置偏移问题
//ios7位置调整
- (void) viewDidLayoutSubviews {
 
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        viewBounds.origin.y = topBarOffset * -1;
        self.view.bounds = viewBounds;
    }
}
```



### AppDelegate
- 如何在其他类调用AppDelegate的东西
```ruby
- (NSArray*)sandwiches {
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    return appDelegate.sandwiches;
}
```

### iOS6 中关于TableViewCell的变更
In iOS versions before iOS 6, when creating a new UITableViewCell, you had to first dequeue the cell, and if you didn’t get a cell via the reusable pool, you had to create the cell explicitly via code. This is no longer necessary in iOS 6, since dequeueReusableCellWithIdentifier:forIndexPath: automatically creates a new cell for you if one isn’t available via the reuse pool, as long as you have a class registered for the cell identifier beforehand. (That’s what you did in viewDidLoad above.)

### 收起键盘的另类方法
```ruby
[view endEditing:NO];
# UIEdgeInsets这个怎么用，出处http://developer.apple.com/library/ios/#documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
```