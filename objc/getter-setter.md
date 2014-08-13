给UIImage添加一个新的title属性
UIImage-Title.h:
```Ruby
@interface UIImage(Title)
@property(nonatomic, copy) NSString *title;
@end
```

UIImage-Title.m:
```Ruby
static char titleKey;

@implementation UIImage(Title)
- (NSString *)title
{
    return objc_getAssociatedObject(self, &titleKey);
}

- (void)setTitle:(NSString *)title
{
    objc_setAssociatedObject(self, &titleKey, title, OBJC_ASSOCIATION_COPY);
}
@end
```
可以看到关键是用到了runtime的两个函数：
1. id objc_getAssociatedObject(id object, void *key)
2. void objc_setAssociatedObject(id object, void *key, id value, objc_AssociationPolicy policy)
该函数中第一位参数表示目标对象，第三个参数表示要添加的属性，第四个参数设置objc_AssociationPolicy，它有以下几个选项：OBJC_ASSOCIATION_ASSIGN，OBJC_ASSOCIATION_RETAIN，OBJC_ASSOCIATION_COPY，分别对应我们在声明属性时的assign,retain,copy。
关于第二个参数，key。因为一个对象可以关联多个新的对像，我们需要一个标志来区分他们。所以这个key就起这样的作用。这里的需要的key的地址，不关心它指向谁。

当我们第二次以新的value调用objc_setAssociatedObject时，如果policy是OBJC_ASSOCIATION_ASSIGN，新的value被关联，对原来旧的value没有任何影响。如果policy是OBJC_ASSOCIATION_RETAIN和OBJC_ASSOCIATION_COPY，新的value被关联，旧的value被release。如果想release原来的value又不关联新的value，，可以用objc_setAssociatedObject直接传一个nil做为value的值。
注意不要使用objc_removeAssociatedObjects，因为它用去掉所有的关联的对象。
关于这段解释，大家可用下面的例子来测试：

main.m
```Ruby
@interface Foo : NSObject {
    NSString *name_;
}
@end

@implementation Foo
- (id)initWithName:(NSString *)name
{
    self = [super init];
    if (!self) return nil;

    name_ = [name copy];
    NSLog(@"Created %@", name_);

    return self;
}

- (void)dealloc
{
    NSLog(@"Destroying %@", name_);
    [name_ release];
    [super dealloc];
}
@end

static char key;

int main (int argc, const char * argv[])
{
    NSAutoreleasePool *pool;
    Foo *target;
    Foo *payload;
    Foo *payload2;

    pool = [[NSAutoreleasePool alloc] init];

    target = [[Foo alloc] initWithName:@"target"];
    payload = [[Foo alloc] initWithName:@"payload"];
    payload2 = [[Foo alloc] initWithName:@"second payload"];

    NSLog(@"Associating payload with target");
    objc_setAssociatedObject(target, &key, payload, OBJC_ASSOCIATION_RETAIN);

    NSLog(@"Releasing payload");
    [payload release];

    NSLog(@"Associating second payload");
    objc_setAssociatedObject(target, &key, payload2, OBJC_ASSOCIATION_RETAIN);

    NSLog(@"Releasing second payload");
    [payload2 release];

    NSLog(@"Releasing target");
    [target release];

    [pool release];

    return 0;
}
```

// Here's the output that this generates:
//
// 2011-12-03 23:03:10.737 MacTest[3953:707] Created target
// 2011-12-03 23:03:10.740 MacTest[3953:707] Created payload
// 2011-12-03 23:03:10.742 MacTest[3953:707] Created second payload
// 2011-12-03 23:03:10.744 MacTest[3953:707] Associating payload with target
// 2011-12-03 23:03:10.745 MacTest[3953:707] Releasing payload
// 2011-12-03 23:03:10.746 MacTest[3953:707] Associating second payload
// 2011-12-03 23:03:10.748 MacTest[3953:707] Destroying payload
// 2011-12-03 23:03:10.749 MacTest[3953:707] Releasing second payload
// 2011-12-03 23:03:10.750 MacTest[3953:707] Releasing target
// 2011-12-03 23:03:10.751 MacTest[3953:707] Destroying target
// 2011-12-03 23:03:10.752 MacTest[3953:707] Destroying second payload

ref:
- http://fanliugen.com/?p=460

--EOF--