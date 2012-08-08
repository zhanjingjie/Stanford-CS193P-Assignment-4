//
//  PhotoViewController.m
//  TopPlaces
//
//  Created by Zhan Jingjie on 8/3/12.
//  Copyright (c) 2012 Zhan Jingjie. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController () <UIScrollViewDelegate>
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
	self.imageScrollView.delegate = self;
	self.imageScrollView.backgroundColor = [UIColor blackColor];
	self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.photoURL]];
}


- (void)viewWillAppear:(BOOL)animated
{
	/*
	UIImage *tmp = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.photoURL]];
	
	CGRect bounds = self.view.bounds;
	CGSize sizeOfImage = tmp.size;
	CGFloat widthRatio = sizeOfImage.width / bounds.size.width;
	CGFloat heightRatio = sizeOfImage.height / bounds.size.height;
	CGSize fitImageSize;
	
	if (widthRatio > heightRatio) {
		fitImageSize.width = bounds.size.width;
		fitImageSize.height = sizeOfImage.height / widthRatio;
	} else {
		fitImageSize.width = sizeOfImage.width / heightRatio;
		fitImageSize.height = bounds.size.height;
	}
	
	UIImage *scaledImage = [self imageWithImage:tmp convertToSize:fitImageSize];
	self.imageView.image = scaledImage;
	
	self.imageScrollView.contentSize = fitImageSize;
	//self.imageView.frame = CGRectMake(0, 0, fitImageSize.width, fitImageSize.height);
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









