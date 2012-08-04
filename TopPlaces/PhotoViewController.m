//
//  PhotoViewController.m
//  TopPlaces
//
//  Created by Zhan Jingjie on 8/3/12.
//  Copyright (c) 2012 Zhan Jingjie. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()
// Make the scroll view an outlet of the controller
@property IBOutlet UIScrollView *imageScrollView;
@end

@implementation PhotoViewController

@synthesize photoURL = _photoURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:self.photoURL]]];
	[self.imageScrollView addSubview:imageView];
	
	// After modify the content size, the image can be scrolled
	// Don't need the scroll bar
	self.imageScrollView.contentSize = imageView.bounds.size;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
