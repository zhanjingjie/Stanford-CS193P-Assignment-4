//
//  PhotoViewController.m
//  TopPlaces
//
//  Created by Zhan Jingjie on 8/3/12.
//  Copyright (c) 2012 Zhan Jingjie. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController () <UIScrollViewDelegate>
// Make the scroll view an outlet of the controller
@property (weak, nonatomic) IBOutlet  UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PhotoViewController

@synthesize photoURL = _photoURL;
@synthesize imageScrollView;
@synthesize imageView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Set this class as the delegate of the scroll view
	self.imageScrollView.delegate = self;
	
	// Load the image and set it as the image
	// Strange behavior when dealing with content size
	self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.photoURL]];

	self.imageScrollView.contentSize = self.imageView.image.size;

	self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
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









