参考：[斯坦福大学iOS7学习笔记](wang9262.github.io/blog/2014/03/01/stanford-ios7-learning/)

###4.Foundation, Attributed Strings (January 17, 2013)
####4.1 Init
NSObject default的Init：
```
@implementation MyObject
- (id)init
{
    self = [super init]; // call our super’s designated initializer 
    if (self) {
        // initialize our subclass here
    }
    return self;
}
@end
```

自己编写的Init：Create a initializer which is not designated:
```
@implementation CalculatorBrain
- (id)initWithValidOperations:(NSArray *)anArray
{
    self = [self init]; // Note that we should call our own designated initializer
    self.validOperations = anArray; // will do nothing if self == nil
    return self;
}
@end
```

####4.2 Dynamic Binding 
DynamicBindingDemo.xcodeproj
```ruby
@interface Vehicle
- (void)move;
@end

@interface Ship : Vehicle
- (void)shoot;
@end

    Ship *s = [[Ship alloc] init];
    [s shoot];
    [s move];
    
    Vehicle *v = s;    // ok
    [v shoot];         // Compiler warning, would not crash #这红色的根本编译不通过
    
    id obj = s; //#=s或者=v都行
    [obj shoot];       // ok
    //[obj someMethodNameThatNoObjectAnywhereRespondsTo]; //Compiler warning. Compiler has never heard of this method.
    
    NSString *hello = @"hello";
    //[hello shoot];     // Compiler warning, and will crash
    
    Ship *helloShip = (Ship *)hello; //#cast hello的类型为Ship
    [helloShip shoot]; // No warning, but crash
    [(id)hello shoot]; // No warning, but crash
```

####4.3 Introspection
* isKindOfClass: returns whether an object is that kind of class (inheritance included)
* isMemberOfClass: returns whether an object is that kind of class (no inheritance)
* respondsToSelector: returns whether an object responds to a given method
Class testing methods take a Class:
```
if ([obj isKindOfClass:[NSString class]]) {
    NSString *s = [(NSString *)obj stringByAppendingString:@”xyzzy”];
}
```