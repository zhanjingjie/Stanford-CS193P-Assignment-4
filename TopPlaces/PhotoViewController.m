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
	self.imageScrollView.backgroundColor = [UIColor blackColor];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}


// In viewWillAppear the screen orientation (bounds) is known
- (void)viewWillAppear:(BOOL)animated
{
	
	// Load the image and set it as the image
	// Strange behavior when dealing with content size
	self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.photoURL]];
	
	// Get the current bounds, consider orientation
	CGRect bounds = self.view.bounds;
	CGSize sizeOfImage = self.imageView.image.size;
	CGFloat widthRatio = sizeOfImage.width / bounds.size.width;
	CGFloat heightRatio = sizeOfImage.height / bounds.size.height;
	CGSize fitImageSize;
	
	// To get the proportional size of the image, based on the current bounds
	if (widthRatio > heightRatio) {
		fitImageSize.width = bounds.size.width;
		fitImageSize.height = sizeOfImage.height / widthRatio;
	} else {
		fitImageSize.width = sizeOfImage.width / heightRatio;
		fitImageSize.height = bounds.size.height;
	}
	
	NSLog(@"Print the screen bounds width: %f, heightL %f", bounds.size.width, bounds.size.height);
	NSLog(@"Print the initial photo width: %f, height: %f", fitImageSize.width, fitImageSize.height);
	NSLog(@"Print the width ratio: %f, height ratio: %f", widthRatio, heightRatio);
	
	self.imageScrollView.contentSize = fitImageSize;
	self.imageView.frame = CGRectMake(0, 0, fitImageSize.width, fitImageSize.height);
	
	/*
	self.imageScrollView.contentSize = self.imageView.image.size;
	self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
	 */

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









