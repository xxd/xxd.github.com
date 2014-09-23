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