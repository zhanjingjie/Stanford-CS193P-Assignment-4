//
//  PhotoViewController.m
//  TopPlaces
//
//  Created by Zhan Jingjie on 8/3/12.
//  Copyright (c) 2012 Zhan Jingjie. All rights reserved.
//

#import "PhotoDisplayViewController.h"

@interface PhotoDisplayViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet  UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PhotoDisplayViewController

@synthesize photoURL = _photoURL;
@synthesize imageScrollView = _imageScrollView;
@synthesize imageView = _imageView;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;



#pragma mark - UISplitViewController Button Dance

- (void)handleSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    NSMutableArray *toolbarItems = [self.navigationController.toolbar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.navigationController.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        [self handleSplitViewBarButtonItem:splitViewBarButtonItem];
    }
}


#pragma mark - UISplitViewController delegate



// By using the protocol, it can work blindly with any detail view controller
// As long as that detailViewController has a property as a button
- (id <splitViewBarButtonPresenter>)splitViewBarButtonItemPresenter
{
	// It seems the last object is the navigation controller
	id detailVC = [self.splitViewController.viewControllers lastObject];
	if ([detailVC isKindOfClass:[UINavigationController class]]) {
		detailVC = [detailVC topViewController];
	}
	if (![detailVC conformsToProtocol:@protocol(splitViewBarButtonPresenter)]) {
		detailVC = nil;
	}
	return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)aViewController
			  inOrientation:(UIInterfaceOrientation)orientation
{
	return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}


- (void)splitViewController:(UISplitViewController *)svc
	 willHideViewController:(UIViewController *)aViewController
		  withBarButtonItem:(UIBarButtonItem *)barButtonItem
	   forPopoverController:(UIPopoverController *)pc
{
	barButtonItem.title = self.title;
	// Tell the detail view to put this button up
	[self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
	 willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	// Tell the detail view to take the button away
	[self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}




#pragma mark - Set the model

// When the model is set, reset the image
- (void)setPhotoURL:(NSURL *)photoURL
{
	if (_photoURL != photoURL) {
		_photoURL = photoURL;
		self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
	}
}


#pragma mark - View Life Cycle


// Set myself as the delegat of the splitViewController
- (void)awakeFromNib
{
	[super awakeFromNib];
	self.splitViewController.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.imageScrollView.delegate = self;
	self.imageScrollView.backgroundColor = [UIColor blackColor];
	self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.photoURL]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	[self setImageScrollView:nil];
	[self setImageView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - UIScrollViewDelegate method

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.imageView;
}





@end









