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
// Can get a UIToolBar from self.navigationController.toolbar

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









