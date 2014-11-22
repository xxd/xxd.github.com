[View controller的生命周期](UIViewControllerLifecycle):Standford 13-14的5.View Controller Lifecycle 45:00笔记

####顺序 
**Instantiated(from storyboard) -> awakeFromNib -> outlets get set -> viewDidload -> viewWillLayoutSubviews -> viewDidiLayoutSubviews -> viewWillAppear-> viewDidAppear -> 如果发生rotation-> viewWillLayoutSubviews -> viewDidiLayoutSubviews -> viewWillDisappear -> viewDidDisappear**

####我面试喜欢问的问题

1. loadView, viewDidLoad, viewWillAppear的调用顺序? `就是这个顺序`
2. viewDidLoad会在什么时候调用?会调用几次? `加载的时候调用，仅一次`
3. viewDidUnload会在什么时候调用？iOS6上怎么处理内存警告? `view释放后调用此方法，iOS5以后就不用了`
4. init方法会加载xib文件吗？`会啊，名字不就是initWithNibName吗，如果只是init，也会调用此方法从main bundle中加载与当前ViewController同名的xib文件`
5. 能把controller1.view添加到controller2.view上面吗？怎么添加?

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