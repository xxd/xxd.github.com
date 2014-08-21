1. BarButtonItems with NSArray **ViewDeckExample.xcodeproj**

>self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects.......... 

//2. UIButton with navigationItem TableSearch.xcodeproj 
UIButton *btnCustom = [UIButton buttonWithType:UIButtonTypeRoundedRect];
UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnCustom];
self.navigationItem.rightBarButtonItem = rightBarButton;

//3. UIButton Programmatically
UIFont *normalFont = [UIFont boldSystemFontOfSize:14];
UIColor *blueColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
UIButton *dropLineBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
[dropLineBtn addTarget:self action:@selector(dropLine:) forControlEvents:UIControlEventTouchUpInside];
[dropLineBtn setTitle:@"抛物线运动" forState:UIControlStateNormal];
[dropLineBtn setBackgroundImage:btnNormalImage forState:UIControlStateNormal];
[dropLineBtn setBackgroundImage:btnPressedImage forState:UIControlStateHighlighted];
[dropLineBtn setTitleColor:blueColor forState:UIControlStateHighlighted];
dropLineBtn.frame = CGRectMake(220, 10, 80, 41);
dropLineBtn.titleLabel.font = normalFont;
[self.view addSubview:dropLineBtn];

//4. UIImage for UIButton
//传统
[self.fullSizeImage setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
[self.fullSizeImage setBackgroundImage:[UIImage imageNamed:@"buttonHighlighted.png"] forState:UIControlStateHighlighted];

//拉伸：The UIEdgeInsets argument takes four floats corresponding to the distance (in density-independent pixels) separating the caps from each side of the image in the following order: top, left, bottom, right.
UIImage *resizableButton = [[UIImage imageNamed:@"resizableButton.png" ] resizableImageWithCapInsets:UIEdgeInsetsMake(17, 5, 17, 5)];
UIImage *resizableButtonHighlighted = [[UIImage imageNamed:@"resizableButtonHighlighted.png" ] resizableImageWithCapInsets:UIEdgeInsetsMake(17, 5, 17, 5)];

//5. UIButton pressed changing background color
UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
NSString* fileLocation = [[NSBundle mainBundle] pathForResource:@"buttonBG" ofType:@"png"];
UIImage* bgImage = [UIImage imageWithContentsOfFile:fileLocation];
if (bgImage != nil) { // check if the image was actually set
  [button setBackgroundImage:bgImage forState:UIControlStateHighlighted];
} else {
  NSLog(@"Error trying to read the background image");
}

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

UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
[btnImage setFrame:CGRectMake(660, 7, 30, 30)];
[btnImage addTarget:self action:@selector(createUntitledFile:) forControlEvents:UIControlEventTouchUpInside];
[btnImage setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
[titleView addSubview:btnImage];
	
//宏
self.navigationItem.leftBarButtonItem = BARBUTTON(@"Action", @selector(sendMail:));

#define BARBUTTON(name, selector) [[UIBarButtonItem alloc] initWithTitle:name style:UIBarButtonItemStyleBordered target:self action:selector]

//Navi右侧放置两个按钮
self.navigationItem.leftBarButtonItem = [[NSMutableArray alloc] initWithObjects:
												[[UIBarButtonItem alloc] initWithTitle:@"Email" 
												style:UIBarButtonItemStyleBordered
												target:self
												action:@selector(sendMail:)],
												[[UIBarButtonItem alloc] initWithTitle:@"SMS" 
												style:UIBarButtonItemStyleBordered
												target:self
												action:@selector(sendSMS:)],nil];