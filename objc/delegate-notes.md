1.**DetailViewController.h**
```
@class DetailViewController;

@protocol DetailViewControllerDelegate <NSObject>

- (void)detailViewControllerDidCancel:(DetailViewController *)controller;
- (void)detailViewControllerDidClose:(DetailViewController *)controller;

@end

@interface DetailViewController : UIViewController <UINavigationBarDelegate>
{
	**id <DetailViewControllerDelegate> delegate;**
}
**@property (nonatomic, assign) id <DetailViewControllerDelegate> delegate;**
```

2.**DetailViewController.m**
```
#import "DetailViewController.h"
@implementation DetailViewController
@synthesize delegate;

- (IBAction)cancel:(id)sender {
	[self.delegate detailViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender {
	[self.delegate detailViewControllerDidClose:self];
}
```

3.**MasterViewController.h**
```
**#import "DetailViewController.h"**

@interface MasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, **DetailViewControllerDelegate**>
```

4.**MasterViewController.m**
```
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ShowDetail"]) {
		DetailViewController *controller = segue.destinationViewController;
		controller.delegate = self;//在需要调用delegate方法的时候调用它
... 
}
```