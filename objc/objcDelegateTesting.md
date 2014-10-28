在前些天使用了NSNotificationCenter解决了在markdown.xcodeproj项目中遇到不能刷新SideBarViewController的问题之后，今天又遇到了一个类似的问题，这次是点击SideBarViewController但是无法刷新ViewController中的mkNameFile和markdownTextView的问题。记录一下我试验过的方法和思考过程

1. 首先，因为不是Master-Detail或者Modal View的结构，当然最方便的Public iVar首当其冲，但是没有反应
```
ViewController *viewController = [[ViewController alloc]init];
viewController.mkNameFile.text = [self.itemArray objectAtIndex:indexPath.row];
viewController.markdownTextView.text = [self openFile:[itemArray objectAtIndex:indexPath.row]];
```

2.那么我就使用了之前在PopList中使用的Delegate照拌了过来
2.1声明Protocol 
**SideBarViewController.h**
```
@classSideBarViewController;
@protocolSideBarViewControllerDelegate <NSObject]] >
-(void)editTextContent:(NSString*)textContent mkFileNamePath:(NSString*)mkFileNamePath;
@end
```

2.2生成object
**SideBarViewController.h**
```
@property(weak,nonatomic)id<SideBarViewControllerDelegate> sideBarDelegate;
```

2.3设置接收者
**ViewController.h**
```
@interfaceViewController :UIViewController<SideBarViewControllerDelegate.....>
@implementationViewController {
SideBarViewController*sideBarViewController;
}
```

**ViewController.m**
```
- (void)viewDidLoad
{
[superviewDidLoad];
sideBarViewController.sideBarDelegate=self;
}
```

2.4传值
**SideBarViewController.m**
```
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
if ([self.sideBarDelegate respondsToSelector:@selector(editTextContent:)])
NSLog( @"delegate yes" );

if(self.sideBarDelegate) {
NSLog(@"fire delegate");
[self.sideBarDelegate editTextContent:[self openFile:[itemArray objectAtIndex:indexPath.row]] mkFileNamePath:[self.itemArray objectAtIndex:indexPath.row] ];
} else
NSLog( @"delegate is null" );
}
```

结果**NSLog(@"delegate is null");**而且，不能够把值传递过去，后来经过浏览Stackoverflow上的一堆问题大概了解到了**问题是ViewController已经init过了，而你的sideBarViewController.sideBarDelegate = self;是在viewDidLoad中写的，那么ViewController不会再init了，所以就无法接收delegate，那么delegate就是null，于是修改为：**

```
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
ViewController*viewController = [[ViewControlleralloc]init];
self.sideBarDelegate = viewController;
if([self.sideBarDelegaterespondsToSelector:@selector(editTextContent:)])
NSLog(@"delegate yes");

if(self.sideBarDelegate) {
NSLog(@"fire delegate");
[self.sideBarDelegateeditTextContent:[selfopenFile:[itemArrayobjectAtIndex:indexPath.row]]mkFileNamePath:[self.itemArrayobjectAtIndex:indexPath.row] ];
}else
NSLog(@"delegate is null");
}
```
ok了

2.5实现，死在这这步了，debug 2.4的问题之后**NSLog(@"received delegate”);可以打印出来了**，但是无法刷新markdownTextView和mkNameFile，所以尝试Block
**ViewController.m**
```
#pragma mark SideBarViewController Delegate methods
-(void)editTextContent:(NSString*)textContent mkFileNamePath:(NSString*)mkFileNamePath {
NSLog(@"received delegate");
self.markdownTextView.text= textContent;
[self.markdownTextViewsetNeedsDisplay];
self.mkNameFile.text= mkFileNamePath;
[self.mkNameFilesetNeedsDisplay];
}
```

3. Blocks这个只是开了个头，但是想到无法接收所以就没有实验
```
typedefvoid(^SideBarViewControllerCompletionBlock)(NSString*mkFileNamePath,NSString*editTextContent);
@property(nonatomic,copy) SideBarViewControllerCompletionBlock completionBlock;
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
if(self.completionBlock!=nil)
self.completionBlock([self.itemArrayobjectAtIndex:indexPath.row],[selfopenFile:[itemArrayobjectAtIndex:indexPath.row]]);
}
```

4.最后用了IIViewDeckController自己的方法
```
#pragma mark - Table view delegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.viewDeckControllercloseLeftViewBouncing:^(IIViewDeckController*controller) {
    if([controller.centerControllerisKindOfClass:[UINavigationControllerclass]]) {
        ViewController* viewController = (ViewController*)           ((UINavigationController*)controller.centerController).topViewController;
        viewController.mkNameFile.text= [self.itemArrayobjectAtIndex:indexPath.row];
    viewController.markdownTextView.text= [selfopenFile:[itemArrayobjectAtIndex:indexPath.row]];
    }
    }];
}
```
--EOF--