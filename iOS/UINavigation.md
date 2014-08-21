- UIBarButtonItem on UINavigation
```ruby
UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] 
                                initWithTitle:@"Done" 
                                style:UIBarButtonSystemItemDone 
                                target:nil action:nil];
UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Title"];
item.rightBarButtonItem = rightButton;
item.hidesBackButton = YES;
[bar pushNavigationItem:item animated:NO];

UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]
                              initWithTitle:@"Flip"
                              style:UIBarButtonItemStyleBordered
                              target:self
                              action:@selector(cancel)];
self.navigationItem.leftBarButtonItem = cancelBtn;
```

- UIButton with navigationItem
```ruby
# **TableSearch.xcodeproj**
UIButton *btnCustom = [UIButton buttonWithType:UIButtonTypeRoundedRect];
UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnCustom];
self.navigationItem.rightBarButtonItem = rightBarButton;

#宏
#define BARBUTTON(name, selector) [[UIBarButtonItem alloc] initWithTitle:name style:UIBarButtonItemStyleBordered target:self action:selector]
self.navigationItem.leftBarButtonItem = BARBUTTON(@"Action", @selector(sendMail:));

```

- Navi右侧放置两个按钮
```ruby
self.navigationItem.leftBarButtonItem = [[NSMutableArray alloc] initWithObjects:												[[UIBarButtonItem alloc] initWithTitle:@"Email" style:UIBarButtonItemStyleBordered target:self action:@selector(sendMail:)], [[UIBarButtonItem alloc] initWithTitle:@"SMS" style:UIBarButtonItemStyleBordered target:self action:@selector(sendSMS:)],nil];
```

- BarButtonItems with NSArray **ViewDeckExample.xcodeproj**
```
self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects.......... 
```

- 按上钮放图片
```
- (void) initNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Button Reload.png"] style:UIBarButtonItemStylePlain target:self action:@selector(sync)];
}
 
# 上面的方法遇到不规则的会拉伸图片，这个方法不会
UIButton *leftCustomBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
[leftCustomBtn setFrame:CGRectMake(0, 0, 40, 40)];
[leftCustomBtn addTarget:self action:@selector(revealSidebar:) forControlEvents:UIControlEventTouchUpInside];
[leftCustomBtn setBackgroundImage:[UIImage imageNamed:@"ButtonMenu.png"] forState:UIControlStateNormal];
UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftCustomBtn];
self.navigationItem.leftBarButtonItem = leftBarButton;
```

- 给Navi加一个TitleView，然后放上按钮
```
UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 700, 44)];
self.navigationItem.titleView = titleView;
```

- UINavigation Programmingly
```ruby
//If you want to have a solid color for your navigation bar in iOS 6 similar to iOS 7 use this
[[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
[[UINavigationBar appearance] setBackgroundColor:[UIColor greenColor];

[self.navigationController.navigationBar setTintColor:[UIColor yellowColor]];

# iOS 7 use the barTintColor
navigationController.navigationBar.barTintColor = [UIColor greenColor];

NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
if ([[ver objectAtIndex:0] intValue] >= 7)
{
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:mainNavController.navigationBar.titleTextAttributes];
    [textAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
}
else
{
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x00cc00);;
}
```

- UISegment on UINavigation http://stackoverflow.com/questions/1900252/adding-buttons-to-navigation-bar
```ruby
- (void)viewDidLoad {
[super viewDidLoad];

 UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
                          [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"up.png"],
                           [UIImage imageNamed:@"down.png"],
                           nil]];
      [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
      segmentedControl.frame = CGRectMake(0, 0, 90, 35);
      segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
      segmentedControl.momentary = YES;

      UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
        [segmentedControl release];

      self.navigationItem.rightBarButtonItem = segmentBarItem;
        [segmentBarItem release];
}

- (void)segmentAction:(id)sender{

  if([sender selectedSegmentIndex] == 0){
   //do something with segment 1
   NSLog(@"Segment 1 preesed");
  }else{
   //do something with segment 2
   NSLog(@"Segment 2 preesed");
  }
}

```