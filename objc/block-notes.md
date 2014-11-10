####要点：
1. block 是分配在 stack 上的，因为在栈中分配内存是比较块的。是栈变量也就意味着它从栈中弹出后就会被销毁这意味着我们必须小心里处理 block 的生命周期；
2. 对于普通的 local 变量，我们就不能在 block 里面随意修改（原因很简单，block 可以被多个线程并行运行，会有问题的）；
3. 该如何修改外部变量呢？有两种办法：
    - 第一种是可以修改 static 全局变量；
    - 第二种是可以修改用新关键字 __block 修饰的变量。

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

