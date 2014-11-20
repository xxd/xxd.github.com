看了Standford 13-14的5.View Controller Lifecycle终于有机会整理一下每天都要用但还是懵懵懂懂的玩意儿了。

UIViewController是MVC中的Controller，负责管理每个窗口界面的视图和数据

我面试喜欢问的问题：
1. loadView, viewDidLoad, viewWillAppear的调用顺序? `就是这个顺序`
2. viewDidLoad会在什么时候调用?会调用几次? `加载的时候调用，仅一次`
3. viewDidUnload会在什么时候调用？iOS6上怎么处理内存警告? `view释放后调用此方法，iOS5以后就不用了`
4. init方法会加载xib文件吗？`会啊，名字不就是initWithNibName吗，如果只是init，也会调用此方法从main bundle中加载与当前ViewController同名的xib文件`
5. 能把controller1.view添加到controller2.view上面吗？怎么添加?

如果你能够回答完上述所有问题，可以不用往下看了:)

**顺序 awakeFromNib -> viewDidload -> viewWillLayoutSubviews(iOS7) -> viewDidiLayoutSubviews(iOS7) -> viewWillAppear-> viewDidAppear**

awakeFromNib(storyboard) 在storyboard的输出口被设置之前调用，所以这里只能做一些必须要在
* before the MVC is loaded

1.init 初始化
- 从xib中加载会调用此方法，如果只是init，也会调用此方法从main bundle中加载与当前ViewController同名的xib文件 `- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;`
- 从storyboard中加载时会调用该方法 `- (id)initWithCoder:(NSCoder *)aDecoder`

2.loadView
从xib或者storyboard中加载view，也可以重载loadView初始化view。

3.viewDidLoad
在loadView后调用，可在此进行一些初始化操作。
> 在iOS 6以前内存警告释放view后，会重新loadView，调用viewDidLoad。注意：这里只是UIViewController自己加载view并初始化层次结构，位置后。最终view的大小会在view添加到屏幕上面后重新计算，在viewWillAppear中的view.bounds才是最终的大小。比如，UIViewController被添加到UINavigationController时，其view的高度可能（请思考为什么是可能？）需要减去navigationBar的高度，但是这里还没有进行此操作。

4.view{Will, Did}LayoutSubviews;
`- (void)view{Will, Did}LayoutSubviews;` iOS7 auto Lay out的方法
在layoutSubviews方法调用后执行，当view.bounds变化时，会触发该方法重新计算布局。

5.viewWillAppear
view即将显示（添加到当前window的view hierarchy 结构）。此时view.bounds已经被重新计算为合适的结果了。如果你需要根据view的高度设置某些控件的高度，这里可以开始动手了。

只需一次性初始化的不要放在该方法中,最好放入viewdidiload。当展示的东西会发生改变时,可以将其放在该方法中,使其同步 一些网络延时等待可以放在这个方法中进而优化,减少等待时间.在该方法中来设置控件尺寸 viewwilldisappear 这个方法一般用来存储当前数据,用作恢复时的重载.

6.viewDidAppear
整个view已经添加到屏幕上面，用户可以看见了。

7.viewWillDisappear, viewDidDisappear与上面两个相反。

8.didReceiveMemoryWarning
> 程序收到内存警告时，调用此方法，默认会释放self.view，如果其没有superview。
注意iOS 6后，收到内存警告后，view不会被释放，viewDidUnload也不会被调用。系统会释放view中包含的一些内容，具体自己debug一下？也可以飘过不用关心。在didReceiveMemoryWarning你可以释放一些可以重生的业务数据。

几个流程：
1.初始化UIViewController
1. `- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;`
2. `- loadView`
3. `- viewDidLoad`


2.显示UIViewController - viewWillAppear
1. `- viewWillLayoutSubviews`
2. `- viewDidLayoutSubviews`
3. `- viewDidAppear`

3.收到内存警告
1. `- didReceiveMemoryWarning`
2. `- viewDidUnload`
