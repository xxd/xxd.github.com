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

#### 在iOS中播放GIF动画图片  
在 iOS App 中，经常会看到一些动画，比如：音乐播放器App， 那个上下跳动的波浪式的图标。 这个动画在iOS中是如何实现的呢？如果你留意的话，会发现这些动画都是Gif 文件。 我们知道，GIF本身就是一个动画，只要能播这个GIF文件就可以了。iPhone SDK提供了多种动画手段，UIView、UIImageView和CALayer都支持动画。但如何处理常见的gif动画呢？UIWebView提供了答案，代码如下：
```ruby
#使用UIWebView播放
    // 设定位置和大小
    CGRect frame = CGRectMake(50,50,0,0);
    frame.size = [UIImage imageNamed:@"play.gif"].size;
    // 读取gif图片数据
    NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"play" ofType:@"gif"]];
    // view生成
    UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
    webView.userInteractionEnabled = NO;//用户不可交互
    [webView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    [self.view addSubview:webView]; 
```

### AppDelegate
- 如何在其他类调用AppDelegate的东西
```ruby
- (NSArray*)sandwiches {
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    return appDelegate.sandwiches;
}
```

### Init Controllers
- init Nib: initWithNibName
```ruby
AskViewController *askVC = [[AskViewController alloc] initWithNibName:@"AskViewController" bundle:nil];
```

- init Storyboard
```ruby
UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SandwichesViewController *vcStoryboard  = [mystoryboard instantiateViewControllerWithIdentifier:@"SnandwichVC"];
```

- init tableview controller
```ruby
DetailTableViewController *detailViewController = [[DetailTableViewController alloc] initWithStyle:UITableViewStylePlain];
```

- init any controller
```ruby
Class vcClass = NSClassFromString(@"ImageTargetsViewController");
id vc = [[vcClass alloc]  initWithNibName:nil bundle:nil];
SampleAppSlidingMenuController *slidingMenuController = [[SampleAppSlidingMenuController alloc] initWithRootViewController:vc]; 
[self.navigationController pushViewController:slidingMenuController animated:NO];
```

- Init another way
```ruby
+ (id)loadController:(Class)classType {
    NSString *className = NSStringFromClass(classType);
    UIViewController *controller = [[classType alloc] initWithNibName:className bundle:nil];
    return controller;
}
    
MyViewController *c = [LayoutUtil loadController:[MyViewController class]];
```

### 选择Xcode版本打包发布App

如何你和我一样手贱安装了Xcode6，同时又需要发布应用到商店时，你会发现打好的包是通不过审核的。验证报错：

    unable to validate application archives of type:0x0

Google报错信息后，发现Beta版的Xcode打的包是不能发布到商店的。这时候即使你启用原来的Xcode5去打包，打出来的包也会报错的。这是因为安装Xcode6Beta以后，本地的命令行工具已经被换成了最新的。

解决的办法如下：通过xcode-select 指定命令行工具版本。

    sudo xcode-select --switch /Applications/Xcode.app
然后使用Xcode5打包即可。

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