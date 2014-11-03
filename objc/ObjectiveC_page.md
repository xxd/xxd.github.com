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

- 理解了Lazy Instantiation

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
