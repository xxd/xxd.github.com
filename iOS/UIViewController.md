看了Standford 13-14的5.View Controller Lifecycle终于有机会整理一下每天都要用但还是懵懵懂懂的玩意儿了。

UIViewController是MVC中的Controller，负责管理每个窗口界面的视图和数据

#### 我面试喜欢问的问题：

1. loadView, viewDidLoad, viewWillAppear的调用顺序? `就是这个顺序`
2. viewDidLoad会在什么时候调用?会调用几次? `加载的时候调用，仅一次`
3. viewDidUnload会在什么时候调用？iOS6上怎么处理内存警告? `view释放后调用此方法，iOS5以后就不用了`
4. init方法会加载xib文件吗？`会啊，名字不就是initWithNibName吗，如果只是init，也会调用此方法从main bundle中加载与当前ViewController同名的xib文件`
5. 能把controller1.view添加到controller2.view上面吗？怎么添加?

如果你能够回答完上述所有问题，可以不用往下看了:)

#### View controller的生命周期 45:00
**顺序 Instantiated(from storyboard) -> awakeFromNib -> outlets get set -> viewDidload -> viewWillLayoutSubviews -> viewDidiLayoutSubviews -> viewWillAppear-> viewDidAppear -> 如果发生rotation-> viewWillLayoutSubviews -> viewDidiLayoutSubviews -> viewWillDisappear -> viewDidDisappear**

0.`- (void)loadView`

从xib或者storyboard中加载view，也可以重载loadView初始化view。
永远不要主动调用这个函数。view controller会在view的property被请求并且当前view值为nil时调用这个函数。如果你手动创建view，你应该重载这个函数。如 果你用IB创建view并初始化view controller，那就意味着你使用initWithNibName:bundle:方法，这时，你不应该重载loadView函数。
> 这个方法的默认实现是这样：先寻找有关可用的nib文件的信息，根据这个信息来加载nib文件，如果没有有关nib文件的信息，默认实现会创建一个空白的UIView对象，然后让这个对象成为controller的主view。
所以，重载这个函数时，你也应该这么做。并把子类的view赋给view属性(property)（你create的view必须是唯一的实例，并且不被其他任何controller共享），而且你重载的这个函数不应该调用super。
如果你要进行进一步初始化你的views，你应该在viewDidLoad函数中去做。在iOS 3.0以及更高版本中，你应该重载viewDidUnload函数来释放任何对view的引用或者它里面的内容（子view等等）。

1.init 初始化

- 从xib中加载会调用此方法，如果只是init，也会调用此方法从main bundle中加载与当前ViewController同名的xib文件 `- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;`
- 从storyboard中加载时会调用该方法 `- (id)initWithCoder:(NSCoder *)aDecoder`

2.`- (void)awakeFromNib`(storyboard) 

* before the MVC is loaded，在storyboard的输出口被设置之前调用，所以这里只能做一些必须要在这个方法用的时候
* outlet还没有连接起来，是view Controller刚从storyboard建的时候，没有完全建好，不过可能有一些事情要在这个方法里面完成，比如splitViewDelegate，需要在非常早期完成。
* Standford 13-14的5.View Controller Lifecycle 44:00左右的时候介绍了这两个init和awakeFromNib方法，基本上大多数的事情都要在viewDidLoad中完成，但是如果要用到这两个方法其中的一个那么需要同时在这两个方法内都执行。比如
```
- (void)setup {...do something can;t wait until viewDidLoad...};
- (void)awakeFromNib { [self setup] };
(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:name bundle:bundle];
  [self setup]; 
  return self;
};
```

3.`- (void)viewDidLoad;`

**这个方法只会在view启动的时候调用一次**

到这一步已经完成的
- ViewController已经完全好了，自己加载view并初始化层次结构，位置后
- storyboard的outlet也已经连接好了。但是还没有在屏幕上显示出来。这个方法里面可以放很多设置的代码。

这一步还没有完成的
- geometry code还没有完成，只是还不能够确定app试运行在一个iPhone 5或者6或者iPad上，所以view的bounds还没有，这些设置要去下一步`- (void)viewWillAppear:(BOOL)animated;`中的view.bounds才是最终的大小。先load，再appear嘛。
- 比如，UIViewController被添加到UINavigationController时，其view的高度可能（请思考为什么是可能？）需要减去navigationBar的高度，但是这里还没有进行此操作。

> 在iOS 6以前内存警告释放view后，会重新loadView，调用viewDidLoad。

4.`- (void)viewWillAppear:(BOOL)animated;`

- 这个方法调用的时候，bounds已经有了。
- 你的视图只会loaded一次，但是会appear或者disappear很多次。所以不变的东西，放在viewDidLoad里面。和几何相关的，放在viewWillAppear里面。这点对项目的优化很重要。就好似顶层的view，旋转ipad什么的都需要改变顶层的view的大小，当一个view controller的生命周期到这里的时候，就可以在这里的最后时刻来调整view的排列或者几何特性。
- 这里也设置做一些lazy execution for performance.比如：需要按一个button，出现一个view什么的。这里设置，开销很大。耗时很长的事情最好在viewWillAppear里另开一个线程运行，然后在view里面放一个小小的spinning wheel。
- view即将显示（添加到当前window的view hierarchy 结构）。此时view.bounds已经被重新计算为合适的结果了。如果你需要根据view的高度设置某些控件的高度，这里可以开始动手了。
- 只需一次性初始化的不要放在该方法中,最好放入viewdidiload。当展示的东西会发生改变时,可以将其放在该方法中,使其同步 一些网络延时等待可以放在这个方法中进而优化,减少等待时间.在该方法中来设置控件尺寸 

5.`- (void)viewDidAppear:(BOOL)animated;`
will的did版本。在view显示之后使用。整个view已经添加到屏幕上面，用户可以看见了。

6.`- (void)view{Will, Did}LayoutSubviews;`
在layoutSubviews方法调用后执行，当view.bounds变化时，会触发该方法重新计算布局。
在由frame的改变而触发输出subview之前，这个方法被调用
比如，在autorotation后，布局发生改变，此时可以设置subview的布局。

7.`- (void)viewWillDisAppear:(BOOL)animated`
```
- (void)viewWillDisappear:(BOOL)animated
{
       [superviewWillDisappear:animated];
       [selfrememberScrollPosition];
       [selfsaveDataToPermanentStore];
}
```
这个方法当然是要消失的时候啦，一般用来存储当前数据,用作恢复时的重载。所以可以记得scroll的position啦。但是，不要在这个方法里面写太多的东西哦，app会崩溃的。另开线程来处理任何UI的改变，或者如果是不怎么废资源的话就直接写入硬盘。

8.didReceiveMemoryWarning
> 程序收到内存警告时，调用此方法，默认会释放self.view，如果其没有superview。
注意iOS 6后，收到内存警告后，view不会被释放，viewDidUnload也不会被调用。系统会释放view中包含的一些内容，具体自己debug一下？也可以飘过不用关心。在didReceiveMemoryWarning你可以释放一些可以重生的业务数据。
低内存的时候，系统会卸载你的view，将会把你的controller的view从内存中清除出去，也就是停止所有有strong指向的指针。但是对应的viewController是不会从heap清除出去的。但是，还是要把其他的outlet指针都设置为nil，因为，就怕其他的view有指向这个类型的strong指针，所以就不太一样了。所以要养成好习惯，把outlet型的指针设置为nil。

所以自己最好释放一下view【但是viewDidUnload在iOS6以后就不支持了所以还是用这个吗？看看其他的源码吧】
```
- (void)viewDidUnload {
  self.faceView =nil;
}
```

#### 关于ratation的更多方法：
- `- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)anOrientation duration:(NSTimeInterval)seconds;`
- `- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOriention)orient duration:(NSTimeInterval)seconds;`
- `- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)anOrientation;`

####几个流程：

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