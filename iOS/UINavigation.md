1. BarButtonItems with NSArray **ViewDeckExample.xcodeproj**
self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects.......... 

- UIButton with navigationItem **TableSearch.xcodeproj**
UIButton *btnCustom = [UIButton buttonWithType:UIButtonTypeRoundedRect];
UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnCustom];
self.navigationItem.rightBarButtonItem = rightBarButton;

//6. UIBarButtonItem on UINavigation
//Sample code to set the right button on a navigation bar.
UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
    style:UIBarButtonSystemItemDone target:nil action:nil];
UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Title"];
item.rightBarButtonItem = rightButton;
item.hidesBackButton = YES;
[bar pushNavigationItem:item animated:NO];

//But normally you would have a navigation controller, enabling you to write:
UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]
                              initWithTitle:@"Flip"
                              style:UIBarButtonItemStyleBordered
                              target:self
                              action:@selector(cancel)];
self.navigationItem.leftBarButtonItem = cancelBtn;

//按上钮放图片
- (void) initNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Button Reload.png"] style:UIBarButtonItemStylePlain target:self action:@selector(sync)];
}
    
//上面的方法遇到不规则的会拉伸图片，这个方法不会
UIButton *leftCustomBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
[leftCustomBtn setFrame:CGRectMake(0, 0, 40, 40)];
[leftCustomBtn addTarget:self action:@selector(revealSidebar:) forControlEvents:UIControlEventTouchUpInside];
[leftCustomBtn setBackgroundImage:[UIImage imageNamed:@"ButtonMenu.png"] forState:UIControlStateNormal];
UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftCustomBtn];
self.navigationItem.leftBarButtonItem = leftBarButton;

//给Navi加一个TitleView，然后放上按钮
UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 700, 44)];
self.navigationItem.titleView = titleView;
