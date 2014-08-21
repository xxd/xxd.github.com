

- UIButton Programmatically
```ruby
UIFont *normalFont = [UIFont boldSystemFontOfSize:14];
UIColor *blueColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
UIButton *dropLineBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect]; #UIButtonTypeCustom
[dropLineBtn addTarget:self action:@selector(dropLine:) forControlEvents:UIControlEventTouchUpInside];
[dropLineBtn setTitle:@"抛物线运动" forState:UIControlStateNormal];
[dropLineBtn setTitleColor:blueColor forState:UIControlStateHighlighted];
dropLineBtn.frame = CGRectMake(220, 10, 80, 41);
dropLineBtn.titleLabel.font = normalFont;

#加图片
NSString* fileLocation = [[NSBundle mainBundle] pathForResource:@"buttonBG" ofType:@"png"];
UIImage* bgImage = [UIImage imageWithContentsOfFile:fileLocation];
if (bgImage != nil) { // check if the image was actually set
  [dropLineBtn setBackgroundImage:btnNormalImage forState:UIControlStateNormal];
[dropLineBtn setBackgroundImage:btnPressedImage forState:UIControlStateHighlighted];
} else {
  NSLog(@"Error trying to read the background image");
}
#加图片简化
[self.fullSizeImage setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
[self.fullSizeImage setBackgroundImage:[UIImage imageNamed:@"buttonHighlighted.png"] forState:UIControlStateHighlighted];

[self.view addSubview:dropLineBtn];
```

- 拉伸
The UIEdgeInsets argument takes four floats corresponding to the distance (in density-independent pixels) separating the caps from each side of the image in the following order: top, left, bottom, right.
```ruby
UIImage *resizableButton = [[UIImage imageNamed:@"resizableButton.png" ] resizableImageWithCapInsets:UIEdgeInsetsMake(17, 5, 17, 5)];
UIImage *resizableButtonHighlighted = [[UIImage imageNamed:@"resizableButtonHighlighted.png" ] resizableImageWithCapInsets:UIEdgeInsetsMake(17, 5, 17, 5)];
```
	
--EOF--
