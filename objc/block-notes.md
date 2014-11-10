####要点：
1. block 是分配在 stack 上的，因为在栈中分配内存是比较块的。是栈变量也就意味着它从栈中弹出后就会被销毁这意味着我们必须小心里处理 block 的生命周期；
2. 对于普通的 local 变量，我们就不能在 block 里面随意修改（原因很简单，block 可以被多个线程并行运行，会有问题的）；
3. 该如何修改外部变量呢？有两种办法：
    - 第一种是可以修改 static 全局变量；
    - 第二种是可以修改用新关键字 __block 修饰的变量。
4. 使用方法：
```ruby
# DetailViewController.h定义Block
typedef void (^DetailViewControllerCompletionBlock)(BOOL success);

@interface DetailViewController : UIViewController

@property (nonatomic, copy) DetailViewControllerCompletionBlock completionBlock;

# DetailViewController.m 赋值
- (IBAction)cancel:(id)sender
{
    if (self.completionBlock != nil) {
        self.completionBlock(NO);
    }
}

- (IBAction)done:(id)sender
{
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	NSNumber *newValue = [formatter numberFromString:self.textField.text];

	self.itemToEdit.value = (newValue != nil) ? newValue : @0;

    if (self.completionBlock != nil) {
        self.completionBlock(YES);
    }
}

# Master内回调，以前纯代码在点击表格的delegate内回调，现在用了StoryBoard在Segue内回调
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDetail"]) {
        DetailViewController *controller = 
                    segue.destinationViewController;

        controller.completionBlock = ^(BOOL success) {
            if (success) {
                // This will cause the table of values to be
                // resorted if necessary.
                [_dataModel clearSortedItems];

                [self updateTableContents];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        };
............
}
```

#### 参考项目：
BlockDemo.xcodeproj，iOSDiner.xcodeproj

#### 参考文章：
- 第1-7点：根据[在iOS4中使用代码块－基础知识](http://www.cocoachina.com/bbs/read.php?tid=62169)和[在iOS4中使用代码块－代码块设计](http://www.cocoachina.com/bbs/read.php?tid=62174)
- 第7点：根据 《iOS_6_by_Tutorials.pdf》P35 Fun with blocks
- 第8，9点：根据[Block全覽](https://www.facebook.com/note.php?note_id=456678673346)
- [Block介绍（一）基础](www.dreamingwish.com/frontui/article/default/block介绍（一）基础.html)
- [Block介绍（二）内存管理与其他特性](www.dreamingwish.com/article/block介绍（二）内存管理与其他特性.html)
- [block介绍（三）揭开神秘面纱（上）](www.dreamingwish.com/article/block介绍（三）揭开神秘面纱（上）.html)
    4. 使用clang的rewrite-objc命令来获取转码后的代码来查看一个block所有的部件：一个主体，一个真正的执行代码函数，一个描述信息(可能包含两个辅助函数)
    5. 构造一个block就是创建了`__main_block_impl_0` 这个c++类的实例
    6. 调用`block blk();` 转码后的语句：`((void (*)(__block_impl *))((__block_impl *)blk)->FuncPtr)((__block_impl *)blk);`
    7. `__weak typeof(self) weakSelf = self;` 或者写成 `__block  OBJ* blockSelf = self;` 来防止retain循环
- [block介绍（四）揭开神秘面纱（下）](www.dreamingwish.com/article/block介绍（四）揭开神秘面纱（下）.html)
- [[深入浅出Cocoa]Block编程值得注意的那些事儿](www.cnblogs.com/kesalin/archive/2013/04/30/ios_block.html)：文章代码KSTestApp.xcodeproj 
正确的做法（被屏蔽的那段代码）是在将block添加到NSArray中时先copy到heap上，这样就可以在之后的使用中正常访问。在ARC下，对block变量进行copy始终是安全的，无论它是在栈上，还是全局数据段，还是已经拷贝到堆上。对栈上的block进行copy是将它拷贝到堆上；对全局数据段中的block进行copy不会有任何作用；对堆上的block进行copy只是增加它的引用记数。如果栈上的block中引用了__block类型的变量，在将该block拷贝到堆上时也会将__block变量拷贝到堆上如果该__block变量在堆上还没有对应的拷贝的话，否则就增加堆上对应的拷贝的引用记数。
- 第10点Block数组：根据[[深入浅出Cocoa]多线程编程之block与dispatch quene](www.cnblogs.com/kesalin/archive/2011/08/26/block_dispatch_queue.html)

---------

1.最简单的Block可以看做是一组可执行的代码
```ruby
^ {
  NSDate *date = [NSDate date];
  NSLog(@"The date and time is %@", date);
};
# 也可以给上面的Block加个名字以及input和output，就可以用now();来调用了
void (^now)(void) = ^ {
  NSDate *date = [NSDate date];
  NSLog(@"The date and time is %@", date);
};
# block名称now，传入void，传出void
```

2.与函数不同是代码块能够捕捉到已声明的同一作用域内的变量，代码块是闭包，在代码块声明时就将使用的变量包含到了代码块范围内。
**#和第一次执行代码块打印出的时间是相同的，只要在程序退出之前，它都是打印最初的日期和时间。这就是闭包的作用域，块内用到的变量做一个只读的备份。但是当你将代码块在不同方法间传递时闭包的特性就会变得十分有用，因为它里面的变量是保持不变的。这也就是为什么Block作为回调会很好用。**
```ruby
void (^now)(void) = ^ {
  NSLog(@"The date and time is %@", date);
};
now();
sleep(5);
date = [NSDate date];
now();

#读可以的，但是需要修改的话，需要__block关键字

__block int multiplier = 3;
[Worker iterateFromOneTo:5 withBlock:^(int number) {
  multiplier = number * multiplier;
  return multiplier;
}];

#如果是一个iVar或者一个method，会报错Capturing 'self' strongly in this block is likely to lead to a retain cycle
__weak typeof(self) weakSelf = self;或者写成__block  OBJ* blockSelf = self;来防止retain循环
[_manager addObserver:self block: ^(DBAccount *account) {
  [weakSelf accountUpdated:account];
}];
```

3.传入参数，返回结果
**代码块变量类似函数指针，调用代码块与调用函数相似。不同于函数指针的是，代码块实际上是Objective-C对象，这意味着我们可以像对象一样传递它们。**
```ruby
^(int number) {
  return number * 3;
};

#例1：传入一个参数，并调用
int (^triple)(int) = ^(int number) {
  return number * 3;
};

int result = triple(2);

#例2：传入两个参数，并调用
int (^multiply)(int, int) = ^(int x, int y) {
  return x * y;
};

int result = multiply(2, 3);
```

4.给Class设计代码块
```ruby
# .h中声明代码块
+ (void)iterateFromOneTo:(int)limit withBlock:(int (^)(int))block;
# block只是这个method的一个参数，整个block是这样的(int (^)(int))block，返回int类型结果，^后没有名字，传入int类型参数，block是参数名随便取的，以便在method内调用block(i)

#三种使用方法
#1) .m中实现：
+ (void)iterateFromOneTo:(int)limit withBlock:(int (^)(int))block {
  for (int i = 1; i <= limit; i++) {
    int result = block(i);
    NSLog(@"iteration %d => %d", i, result);
  }
}

#2)外部调用：
[Worker iterateFromOneTo:5 withBlock:^(int number) {
  return number * 3;
}];

#3)也可以定义一个block作为参数传入：
int (^tripler)(int) = ^(int number) {
  return number * 3;
};

[Worker iterateFromOneTo:5 withBlock:tripler];
```

5.善于使用Typedef来整理遍布各处导致混乱的block名称
```ruby
#原来我们是这样声明的
+ (void)iterateFromOneTo:(int)limit withBlock:(int (^)(int))block;

#.h中用Typedef来声明代码块，typedef是C语言的一个关键字，其作用可以理解为将一个繁琐的名字起了一个昵称。参考项目: AFHTTPClient+Helper.h和PTBlockEventListener.h
typedef int (^ComputationBlock)(int);
@property (nonatomic,copy) ComputationBlock computationBlock;
# @property后就可以从其他类引用了。因为代码块是对象，你可以像实例变量或属性一样使用它。这里我们将它当作属性使用。参考项目：DetailViewController.h @ TheProject.xcworkspace
+ (void)iterateFromOneTo:(int)limit withBlock:(ComputationBlock)block;

#1).m中实现：
+ (void)iterateFromOneTo:(int)limit withBlock:(ComputationBlock)block {
  for (int i = 1; i <= limit; i++) {
    int result = block(i);
    NSLog(@"iteration %d => %d", i, result);
  }
}

#2)外部调用是不变的：
[Worker iterateFromOneTo:5 withBlock:^(int number) {
  return number * 3;
}];

#事实上，你可以使用ComputationBlock在你程序的任何地方，只要import “Worker.h”
# iOS4的API中有很多类似的typedef，例如，ALAssetsLibrary类定义了下面的方法：
- (void)assetForURL:(NSURL *)assetURL     
resultBlock:(ALAssetsLibraryAssetForURLResultBlock)resultBlock
  failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock
#这个方法调用两个代码块，一个代码块时找到所需的资源时调用，另一个时没找到时调用。它们的typedef如下：
typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);
```

6.代码块返回值为代码块
```ruby
ComputationBlock block = [Worker raisedToPower:2];
# 代码块分配内存的方法：代码块的生命周期是在栈中开始的，因为在栈中分配内存是比较块的。是栈变量也就意味着它从栈中弹出后就会被销毁。
+ (ComputationBlock)raisedToPower:(int)y {
  ComputationBlock block = ^(int x) {
    return (int)pow(x, y);
  };
  return [[block copy] autorelease];
}
# 在方法中创建了代码块并将它返回。这样创建代码块就是已明确代码块的生存周期了，当我们返回代码块变量后，代码块其实在内存中已经被销毁了。解决办法是在返回之前将代码块从栈中移到堆中。这听起来很复杂，但是实际很简单，只需要简单的对代码块进行copy操作，代码块就会移到堆中。
```

7.用Block代替Delegate+Protocol《iOS_6_by_Tutorials.pdf》P35 Fun with blocks，代码实践：TheProject.xcworkspace
```ruby
# DetailViewController.h中定义和实现
typedef void (^DetailViewControllerCompletionBlock)(BOOL success);
@property (nonatomic, copy) DetailViewControllerCompletionBlock completionBlock;
# 如果没有typedef就要写成下面这样了
@property (nonatomic, copy) void (^completionBlock)(BOOL success);
- (void)cancel {
  if(self.completionBlock!=nil)
  self.completionBlock(NO,0);
}

- (void)done {   
  if(self.completionBlock!=nil)
  self.completionBlock(YES,3);
}

TimelineTableViewController.m中回调
   DetailViewController*detailVC = [[DetailViewControlleralloc]init];
    detailVC.completionBlock= ^(BOOLsuccess,intnum)
    {
        if (success)
        {
            number += num;
            self.navigationItem.title = [NSString stringWithFormat:@"%i",number];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    };
```

8. Block中的变量，除了第2点中提到的使用`__block variable`用来修改值
```ruby
#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    static int outA = 8;
    int outB = 8;
    int (^myPtr1) (int) = ^(int a) {return outA*a;};
    int (^myPtr2) (int) = ^(int a) {return outB*a;};
    # 在呼叫myPtr之前改變outA和outB的值
    outA = 5;
    outA = 5;
    int result1 = myPtr1(3);# result的值是15，因為outA是個static變數會直接反應其值
    int result2 = myPtr2(3);
    NSLog(@"result1:%i",result1);
    NSLog(@"result2:%i",result2);
  }
  return 0;
}
# 结果：
2013-04-22 13:45:47.642 Untitled[16108:707] result1:15
2013-04-22 13:45:47.642 Untitled[16108:707] result2:24
```

9. Block的生命周期，在第6点中也提到过如果一个block的返回值为一个block，那么需要`return [block copy];`
```ruby
#import <Foundation/Foundation.h>

typedef int (^MyBlock)(int);
MyBlock genBlock();
int main(int argc, const char * argv[])
{
  MyBlock outBlock = genBlock();
  int result = outBlock(5);       
  NSLog(@"result is %d",[outBlockretainCount] );
  NSLog(@"result is %d",result  );       
  return 0;
}

MyBlock genBlock() {           
  int a = 3;           
  MyBlock inBlock = ^(int n) {return n*a;};
  return [[inBlock copy] autorelease];# copy指令是為了要把block從stack搬到heap，autorelease是為了平衝retainCount加到autorelease oop，回傳之後等到事件結束就清掉。
}
```

10. block数组 Block与dispatch_Quene
```ruby
void (^blocks[2])(void) = {
  ^(void){ NSLog(@" >> This is block 1!"); },
  ^(void){ NSLog(@" >> This is block 2!"); }
};

blocks[0]();
blocks[1]();
```

11.何时用dispatch_group_async参考 [GCD介绍（二）: 多核心的性能](www.dreamingwish.com/frontui/article/default/gcd介绍（二）-多核心的性能.html)

--EOF--