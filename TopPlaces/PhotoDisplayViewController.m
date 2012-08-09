//
//  PhotoViewController.m
//  TopPlaces
//
//  Created by Zhan Jingjie on 8/3/12.
//  Copyright (c) 2012 Zhan Jingjie. All rights reserved.
//

#import "PhotoDisplayViewController.h"

@interface PhotoViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet  UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PhotoViewController

@synthesize photoURL = _photoURL;
@synthesize imageScrollView;
@synthesize imageView;



// A helper method to set the contentSize when first appear on screen and when rotation occurs
- (void)resetContentSize
{
	CGSize bounds = self.view.bounds.size;
	CGSize imageSize = self.imageView.image.size;
	CGSize fitSize;
	
	// eg. if widthRatio > heightRatio, then use the bounds.width as the width of the image and imageSize/widthRatio as the height
	CGFloat widthRatio = imageSize.width / bounds.width;
	CGFloat heightRatio = imageSize.height / bounds.height;
	
	if (widthRatio >= heightRatio) {
		fitSize.width = bounds.width;
		fitSize.height = imageSize.height / widthRatio;
	} else {
		fitSize.width = imageSize.width / heightRatio;
		fitSize.height = bounds.height;
	}
		
	self.imageScrollView.contentSize = fitSize;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.imageScrollView.delegate = self;
	self.imageScrollView.backgroundColor = [UIColor blackColor];
	self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.photoURL]];
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	[self resetContentSize];
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

// Will handle the new contentSize after rotation
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self resetContentSize];
}


#pragma mark - UIScrollViewDelegate method

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.imageView;
}



@end









