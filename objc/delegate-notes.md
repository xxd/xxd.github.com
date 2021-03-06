1.**DetailViewController.h**
```ruby
@class DetailViewController;

@protocol DetailViewControllerDelegate <NSObject>

- (void)detailViewControllerDidCancel:(DetailViewController *)controller;
- (void)detailViewControllerDidClose:(DetailViewController *)controller;

@end

@interface DetailViewController : UIViewController <UINavigationBarDelegate>
{
	id <DetailViewControllerDelegate> delegate;
}
@property (nonatomic, assign) id <DetailViewControllerDelegate> delegate;
```

2.**DetailViewController.m**
```ruby
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
```ruby
#import "DetailViewController.h"

@interface MasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DetailViewControllerDelegate>
```

4.**MasterViewController.m**
```ruby
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ShowDetail"]) {
		DetailViewController *controller = segue.destinationViewController;
		controller.delegate = self; #在需要调用delegate方法的时候调用它
............ 
}

#pragma mark - DetailViewControllerDelegate

- (void)detailViewControllerDidCancel:(DetailViewController *)controller
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)detailViewControllerDidClose:(DetailViewController *)controller
{
	NSMutableArray *valuesArray = [[[valuesDictionary objectForKey:controller.sectionName] mutableCopy] autorelease];
	[valuesArray replaceObjectAtIndex:controller.indexInSection withObject:controller.value];

	[valuesDictionary setObject:valuesArray forKey:controller.sectionName];

	// This will cause the table of values to be resorted if necessary.
	[sortedNames release];
	sortedNames = nil;

	[self updateTableContents];

	[self dismissModalViewControllerAnimated:YES];
}
```