#####使用drawRect方法自定义UITableviewCell http://fanliugen.com/?p=33
这期项目安排比较轻松，今天又遇到一个自定义cell的界面。前段时间看官方例子用drawRect方法自定义，听说这样效率也相当高。不会有什么卡。试着就写了写。
```
- (void)drawRect:(CGRect)rect
{
     [self.portrait drawInRect:CGRectMake(10, 5, 50, 50)];
     [self.name drawInRect:CGRectMake(80, 20, 240, 20) withFont:[UIFont systemFontOfSize:15]];
}
```
上面两个成员变量，portrain是个UIImage,name是个NSString。用着API很容易的就写出了。界面也很easy的就画上去了。不过这时的cell中的内容都是重复的，上面出现过一次下面再次显示。
后来一打听，才知道cell用draw的这种方法绘制，必须自己刷新。思考一下也对，自己画了就得自己刷新。平时用控件addsubview不用考虑这些，是因为控件内部有相应的机制，只要你改上面显示的内容它就会自动刷新。
解决方法有两种：
1.在`- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath`里，return cell之前加上`[cell setNeedsDisplay];`
2.在相当属性的set方法中加上刷新的代码，比如
```
-(void)setName:(NSString *)name
{
     [_name release];
     _name = [name retain];
     [self setNeedsDisplay];
}
```
但对比两种方法，第一种貌似更好一些，因为第二种当遇到有多个属性的时候，每次赋值都得刷新，对cell的显示效率不是很好。
>调用[self setNeedsDisplay];并不会立刻执行drawRect:
You can use this method or the setNeedsDisplayInRect: to notify the system that your view’s contents need to be redrawn. This method makes a note of the request and returns immediately. The view is not actually redrawn until the next drawing cycle, at which point all invalidated views are updated.
**实际只是标记下需要重绘而已。