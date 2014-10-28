加下划线是为了区别成员变量名与局部变量名
you access the property with self.segmentedControl, and the instance variable with _segmentedControl.
```
@synthesize happiness;  //如果不写 = _happiness
-(void) setHappiness:(int)happiness {...} // OC 会自动填充完成setter语句
``
自己重写setter的时候，因为OC会自动填充完成setter方法，方法里面的参数名字会是happiness，如果前面没有用=_happiness，setter方法里面的参数名字和ivar是一样的，这样会造成混乱，方法里面用的究竟是参数的ivar还是类里面的ivar。

方法1：必须把参数的ivar名字改成和类里面的ivar不同的名字，例如这样写
```
@synthesize happiness;
-(void) setHappiness:(int)theHappiness // 改成theHappiness不一样的名字，如果不改happiness=happiness//这里发生混淆
{ 
...
}
```

方法2：
```
@synthesize happiness = _happiness 
-(void) setHappiness:(int)happiness // 不冲突了
{
...    
}
```
这样参数的ivar就是happiness，类的ivar就是_happiness，就不会弄错了。
