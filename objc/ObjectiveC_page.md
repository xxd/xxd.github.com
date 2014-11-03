#### Blogs
- https://github.com/tangqiaoboy/iOSBlogCN
- [objc.io](http://www.objc.io/)
- [Ray Wenderlich](http://www.raywenderlich.com)
- [iOS Developer Tips](http://iosdevelopertips.com/)
- [iOS Dev Weekly](http://iosdevweekly.com/)
- [NSHipster](http://nshipster.com/)
- [Bartosz Ciechanowski](http://ciechanowski.me)
- [Big Nerd Ranch Blog](http://blog.bignerdranch.com)
- [Nils Hayat](http://nilsou.com/)

------

#### 理解了Lazy Instantiation

比如我们init一个Class或者一个NSMutableXXX时候一般都在- (void)viewDidLoad 干，但是有时候我们不一定要在View初始化的时候就alloc内存init这个实例，所以我们等到需要他的时候再alloc和init它，这个就需要在他的Setter中完成了，比如一个类
```
- (CalculatorBrain*)calculatorBrain {
    if (!_calculatorBrain) _calculatorBrain = [[CalculatorBrain alloc]init ];
    return _calculatorBrain;
}
```
比如一个NSMutableArray
```
- (NSMutableArray *)programStack {
    if (!_programStack) _programStack = [[NSMutableArray alloc]init];
    return _programStack;
}
```

#### @interface和 @property 方式声明变量的区别
1.在  @interface :NSObject{} 的括号中，当然NSObject 是指一个父类，可以是其他的。
```
@interface GCTurnBasedMatchHelper : NSObject {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
}
```
2.用 @property 去定义一个变量：用了@property去定义，一般要在.m文件中用@synthsize去合成相应的setter，getter方法。否则会得到一个警告。当然@synthsize是可选的，但是是Apple推荐的
@property (assign, readonly) BOOL gameCenterAvailable;

那这两种方式有什么区别呢。

    1. 只在@interface中定义变量的话，你所定义的变量只能在当前的类中访问，在其他类中是访问不了的；而用@property声明的变量可以在外部访问。

    2.用了@property去声明的变量，可以使用“self.变量名”的方式去读写变量。而用@interface的方式就不可以。

    3.  这里给出一个链接：http://stackoverflow.com/questions/9702258/difference-between-properties-and-variables-in-ios-header-file    里面讲到：  我英语菜，简单翻一下：

Defining the variables in the brackets simply declares them instance variables.

在括号中定义一个变量只是简单的声明了一个实例变量（实例变量应该指的成员变量）。  博主注：老外对variable 和instance variable是有不同理解的。所以下文中 用了一个模糊的词 ivar。

声明（和 @synthsize）一个属性会为成员变量生成 getter 和setter方法，根据括号内的标准,在oc中经常用setter和getter 做内存管理，这是很重要的。（例如： 当一个值被赋给这个变量，对象是通过setter函数去分配，修改计数器，并最后释放的）。更高一个层次来说，这种做法也促进了封装，减少了一些不必要的代码。

目前苹果（在模板中）建议的方法是这样的：

-Define property in header file, e.g.:

先在头文件中定义一个属性

1 @property int gameCenter;
Then synthesize & declare ivar in implementation:

然后在实现文件中  synthsize和declare成这样：

1 @synthesize gameCenter = __ gameCenter;

最后一行synthsize  gameCenter 属性并说明了不管什么值被分配给这个属性，都会存储到_gameCenter这个变量中。 再次说明，这不是必要的，但是，这样写了之后，你能减少输入已经明确命名的变量名。

可以使得 @synthsize 时内部getter方法会展成

1 -(int)gameCenter
2 {
3    return  _gameCenter;
4 }
　而直接写  @synthsize  gameCenter；

setter函数会在内部展开成

1 -(int)gameCenter
2 {
3    return  gameCenter;
4 }
　　注意到：函数名和变量名是一样的。在斯坦福的课程中，白胡子教授也模糊的说道这样的同名有可能带来bug，具体什么bug他没说，我也没见过，所以还是养成这样写的习惯为好。其他语言的getter函数  一般会在变量前加 get；但oc没有，可能是为了与其他语言做区分，算是oc的特色，结果却带来这么个麻烦。