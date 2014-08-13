参考项目
objc-message.xcodeproj

参考文章：

1. [Objective-C中一种消息处理方法performSelector: withObject: by xxd](http://www.cnblogs.com/buro79xxd/archive/2012/04/10/2440074.html)
2. [Objective-C Message](http://www.cnblogs.com/studentdeng/archive/2011/10/06/2199873.html)
3. [Objective-C的消息传递机制 by Keakon](http://www.keakon.net/2011/08/10/Objective-C的消息传递机制)
4. [NSInvocation简单使用 « akwei的开发笔记](http://www.dev3g.com/?p=36)

----

Objective-C是动态定型（dynamicaly typed)所以它的类库比C++要容易操作。Objective-C 在运行时可以允许根据字符串名字来访问方法和类，还可以动态连接和添加类。这点没有体会到，有没有对比例子？
method(或者performSelector:withObject:) -> _cmd -> objc_msgSend -> IMP

比如说我在其他语言调用一个function那么就是：f=className.functionName()。但是基于消息模式就是向一个object例如conroller或者Method发送message，例如
[self presentViewController:mailController animated:YES completion:nil];
然后你还可以有很多种方法通过message去查看method是否存在，属于那个class，像极了Ruby

<Objective-C Message>笔记
而这写消息都是通过这个SEL类型的selector来发送的

当我们写好如下的代码时
- (int)foo:(NSString *)str { ...}

编译器事实上转成了下面的样子
int XXXX_XXXX_foo_(SomeClass *self, SEL _cmd, NSString *str) { ...}

当我们写下发送消息的代码如
int result = [obj foo:@"hello"];

实际上变成了
int result = ((int (*)(id, SEL, NSString *))objc_msgSend)(obj, @selector(foo:), @"hello");

⁃其中的 objc_msgSend 是一个我们非常熟悉的C函数定义 id objc_msgSend(id theReceiver, SEL theSelector, ...) 其中theReceiver是调用对象，theSelector则是消息名，省略号就是C语言的不定参数了。那么，objective-c发送消息就变成了一个表面上看似容易理解的C函数调用了，后面我们可以看出它是用汇编来写的
⁃其中的id其实是一个可以指向任何一个object指针（只要结构体中包含isa 指针） 他的结构是这样的
typedef struct objc_object {
Class isa;
} *id;
⁃SEL可以理解为是一个const char *的指针。而它会根据runtime的改变而改变，目前就把SEL仅仅看做是函数名而已
SEL selector = @selector(message); //@selector不是函数调用，只是给这个坑爹的编译器的一个提示
NSLog (@"%s", (char *)selector);   //打印message名称

那么再回到int result = ((int (*)(id, SEL, NSString *))objc_msgSend)(obj, @selector(foo:), @"hello");
它的问题是编译器无法根据id 和SEL 获得完整的函数签名，编译器对参数个数和类型，完全不知道，注意这里用的是函数签名，什么是函数签名呢？它和函数名有什么不同呢？
比如这两个函数有着相同的函数名，但是函数签名不同
-(void)setWidth:(int)width；
-(void)setWidth:(double)width；
这也就导致了objective-c在处理有相同函数名和参数个数但类型不同的函数时非常的弱。而我们在实际开发中只能被迫写成(不过我觉得也挺好的，很清楚，就是太臃肿了，如果没有xcode和自动补全就疯了)：
-(void)setWidthIntValue:(int)width；
-(void)setWidthDoubleValue:(double)width；

继续将message的故事，objc_msgSend 这里传入了 class 指针 self 函数名SEL 已经后面通过C的不定参数传入的参数。通过这些条件。就像之前的C++函数那样，需要查表，并找到相应函数的位置，然后call xxxxx。那么。objective-c是如何找到这些函数的真实地址呢？
method就是这么简单，一个函数名SEL，一个包括的参数类型和返回类型的type，最后加一个IMP。而IMP 就是一个函数指针，指向我们真正的代码位置
typedef id (*IMP)(id, SEL, ...);
那么objc_msgSend 做的事情，就是通过我们传入的self 指针，找到class 的method_list 然后根据SEL 做比较，没有的话，就在super class 找，如此往复。直到找到匹配的SEL，然后，call imp。
那么，我们就发现了。如果object c 这样设计，调用函数的成本实在是太高了，相对传统的C函数调用。那么编译器和runtime又做了那些优化呢？有意思的事情开始了。优化有两个方法
1.字符串比较：runtime将selector实现为一个经过优化的Hash表，里边只存已经经过优化压缩的函数名
2.缓存函数名：因为根据二八原则真正常用的函数名只有20%，那么缓存他们

<Objective-C的消息传递机制 by Keakon> 终于到了能看懂这篇，并且觉得写的好的这一天了，NSInvocation还是没有看进去
根据现有的知识我知道了，在 iOS中可以直接调用 某个对象的消息 方式有2种：
1.一种是performSelector:withObject:比较简单，能完成简单的调用，method(或者performSelector:withObject:) -> _cmd -> objc_msgSend -> IMP
2.再一种就是NSInvocation可以处理参数、返回值。

测试下objc_msgSend：
#import <objc/message.h> //要使用objc_msgSend的话，就要引入这个头文件
Test *test = [[Test alloc] init];
CGPoint point = {123, 456};
NSLog(@"%@", objc_msgSend(test, @selector(pointToString:), point));
NSLog(@"%@", objc_msgSend(test, (SEL)"pointToString:", point));

在ARC中改为
PerformSelectorTest *performSelectorTest = [[PerformSelectorTest alloc] init];
CGPoint point = {123, 456};
NSLog(@"%@", [performSelectorTest performSelector:@selector(pointToString:) withObject:(__bridge id)(&point)]);
到这也证明了<Objective-C Message>所说的这种实现方式只能确定消息名和参数数目，而参数类型和返回类型就给抹杀了。所以编译器只能在编译期警告你参数类型不对，而无法阻止你传递类型错误的参数
我的blog <Objective-C中一种消息处理方法performSelector: withObject:]] > 中总结过NSObject协议提供的一些传递消息的方法：
- (id)performSelector:(SEL)aSelector
- (id)performSelector:(SEL)aSelector withObject:(id)anObject
- (id)performSelector:(SEL)aSelector withObject:(id)anObject withObject:(id)anotherObject
也没有觉得很无语？为什么参数必须是对象？为什么最多只支持2个参数？（我觉得它的实现和Ruby一样，Ruby中就有Arguments List 那个概念其实就是把参数放入Hash然后传过去，这样只要一个参数就行了可能其他语言转过来就想不到）而且你传给它什么都行不一定是一个Object，例如
NSLog(@"%@", [test performSelector:@selector(intToString:) withObject:(id)123]);
可是double和struct就不能这样传递了，因为它们占的字节数和指针不一样。如果非要用performSelector的话，就只能修改参数类型为指针了：
double number = 123.456;
NSLog(@"%@", [test performSelector:@selector(doubleToString:) withObject:(id)(&number)]);
但是有一种情况是你想写一个通用的消息传递的方法但是你没法预知参数的个数，总不能到每个接收消息的函数中去把每个参数在不在都判断个遍吧，这时就要轮到NSInvocation登场了这个以后再整理累了

以斐波那契数列为例看看一个method的转变：method(或者performSelector:withObject:) -> _cmd -> objc_msgSend -> IMP
- (NSInteger)fibonacci:(NSInteger)n {
if (n > 2) {
return [self fibonacci:n - 1] + [self fibonacci:n - 2];
}
return n > 0 ? 1 : 0;
}

改成用_cmd实现就变成了这样：
return (NSInteger)[self performSelector:_cmd withObject:(id)(n - 1)] + (NSInteger)[self performSelector:_cmd withObject:(id)(n - 2)];

或者直接用objc_msgSend：
return (NSInteger)objc_msgSend(self, _cmd, n - 1) + (NSInteger)objc_msgSend(self, _cmd, n - 2);

每次都通过objc_msgSend来调用显得很费劲，有没有办法直接进行方法调用呢？答案是有的，这就需要用到IMP了。IMP的定义为“id (*IMP) (id, SEL, …)”，也就是一个指向方法的函数指针。
NSObject提供methodForSelector:方法来获取IMP，因此只需稍作修改就行了：
- (NSInteger)fibonacci:(NSInteger)n {
static IMP func;
if (!func) {
func = [self methodForSelector:_cmd];
}

if (n > 2) {
return (NSInteger)func(self, _cmd, n - 1) + (NSInteger)func(self, _cmd, n - 2);
}
return n > 0 ? 1 : 0;
}
现在运行时间比刚才减少了1/4，还算不错。

顺便再展现一下Objective-C强大的动态性，给Test类添加一个sum:and:方法：
NSInteger sum(id self, SEL _cmd, NSInteger number1, NSInteger number2) {
return number1 + number2;
}

class_addMethod([Test class], @selector(sum:and:), (IMP)sum, "i@:ii"); //其中 i@:ii的意思是：int id SEL int int
NSLog(@"%d", [test sum:1 and:2]);
class_addMethod的最后那个参数是函数的返回值和参数类型，详细内容可以参考Type Encodings文档。

各种关于SEL的方法
-(BOOL) respondsToSelector:(SEL)aSelector {
printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
return [super respondsToSelector:aSelector];
}

//这就是message forwarding
if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]){
[self.delegate scrollViewDidScroll:scrollView];
}

//10秒钟之后给method发消息
[self performSelector:@selector(stopTimer) withObject:nil afterDelay:10.0];

Hook Objective-C 的方法 http://www.cnblogs.com/Proteas/archive/2013/01/07/2849697.html
下面以对 UIWebView 的 loadRequest: 挂钩子作为例子，来说明如何在 Objective-C 中挂钩子。
类名：UIWebView
方法名：loadRequest:
对应的C原型：
typedef void (*UIWebView_loadRequest__IMP)(UIWebView* self, SEL _cmd, NSURLRequest *request);
static UIWebView_loadRequest__IMP original_UIWebView_loadRequest;
void replaced_UIWebView_loadRequest(UIWebView* self, SEL _cmd, NSURLRequest *request) {
    original_UIWebView_loadRequest(self, _cmd, request);
    // TODO:
}

// 在某个点，例如：application:didFinishLaunchingWithOptions: 中加入如下代码，就完成了挂钩。
Method method = class_getInstanceMethod(NSClassFromString(@"UIWebView"), @selector(loadRequest:));
original_UIWebView_loadRequest = method_setImplementation(method, replaced_UIWebView_loadRequest);
--EOF--