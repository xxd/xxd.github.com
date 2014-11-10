####要点：
1. block 是分配在 stack 上的，因为在栈中分配内存是比较块的。是栈变量也就意味着它从栈中弹出后就会被销毁这意味着我们必须小心里处理 block 的生命周期；
2. 对于普通的 local 变量，我们就不能在 block 里面随意修改（原因很简单，block 可以被多个线程并行运行，会有问题的）；
3. 该如何修改外部变量呢？有两种办法：
    - 第一种是可以修改 static 全局变量；
    - 第二种是可以修改用新关键字 __block 修饰的变量。

#### 参考项目：
BlockDemo.xcodeproj，iOSDiner.xcodeproj

#### 参考文章：
- 1-7点：根据[在iOS4中使用代码块－基础知识](http://www.cocoachina.com/bbs/read.php?tid=62169)和[在iOS4中使用代码块－代码块设计](http://www.cocoachina.com/bbs/read.php?tid=62174)
- 7点根据 《iOS_6_by_Tutorials.pdf》P35 Fun with blocks
- 8，9点根据[Block全覽](https://www.facebook.com/note.php?note_id=456678673346)
[Block介绍（一）基础](www.dreamingwish.com/frontui/article/default/block介绍（一）基础.html)
[Block介绍（二）内存管理与其他特性](www.dreamingwish.com/article/block介绍（二）内存管理与其他特性.html)
[block介绍（三）揭开神秘面纱（上）](www.dreamingwish.com/article/block介绍（三）揭开神秘面纱（上）.html)
[block介绍（四）揭开神秘面纱（下）](www.dreamingwish.com/article/block介绍（四）揭开神秘面纱（下）.html)

---------

1.