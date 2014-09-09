如果你想要如丝般顺滑的效果，那么：http://www.zhihu.com/question/20382396

1. 每次都看一下有没有能重用的 cell，而不是永远重新新建（这个是 UITableView 的常识）
2. Cell 里尽量不要用 UIView 而是全部自己画
3. 图片载入放到后台进程去进行，滚出可视范围的载入进程要 cancel 掉
4. 圆角、阴影之类的全部 bitmap 化，或者放到后台 draw 好了再拿来用
5. Cell 里要用的数据提前缓存好，不要现用现去读文件
6. 数据量太大

来不及一次读完的做一个 load more cell 出来，尽量避免边滚边读数据，这样就算是双核的 CPU 也难保不会抽。做到以上6条的话，应该就能做出很顺畅的滚动了（现在的 Twitter 官方客户端的原作者写过一篇文章，总结起来也无非就是我说的前3条，可以找来看看）。
- Path 2.5 的那个滚动说实在的不是很顺畅，图片显示出来的时候都会抽一下，他们还有很大的改进余地。
- +不要每个view都透明

### 使用drawRect方法自定义UITableviewCell http://fanliugen.com/?p=33
这期项目安排比较轻松，今天又遇到一个自定义cell的界面。前段时间看官方例子用drawRect方法自定义，听说这样效率也相当高。不会有什么卡。试着就写了写。

```Ruby
- (void)drawRect:(CGRect)rect
{
     [self.portrait drawInRect:CGRectMake(10, 5, 50, 50)];
     [self.name drawInRect:CGRectMake(80, 20, 240, 20) withFont:[UIFont systemFontOfSize:15]];
}
```
上面两个成员变量，portrain是个UIImage,name是个NSString。用着API很容易的就写出了。界面也很easy的就画上去了。不过这时的cell中的内容都是重复的，上面出现过一次下面再次显示。
后来一打听，才知道cell用draw的这种方法绘制，必须自己刷新。思考一下也对，自己画了就得自己刷新。平时用控件addsubview不用考虑这些，是因为控件内部有相应的机制，只要你改上面显示的内容它就会自动刷新。
解决方法有两种：
1. 在`- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath`里，return cell之前加上`[cell setNeedsDisplay];`
2. 在相当属性的set方法中加上刷新的代码，比如

```Ruby
-(void)setName:(NSString *)name
{
     [_name release];
     _name = [name retain];
     [self setNeedsDisplay];
}
```

但对比两种方法，第一种貌似更好一些，因为第二种当遇到有多个属性的时候，每次赋值都得刷新，对cell的显示效率不是很好。
调用`[self setNeedsDisplay];`并不会立刻执行drawRect:，**实际只是标记下需要重绘而已。**
You can use this method or the setNeedsDisplayInRect: to notify the system that your view’s contents need to be redrawn. This method makes a note of the request and returns immediately. The view is not actually redrawn until the next drawing cycle, at which point all invalidated views are updated.

------

--EOF--