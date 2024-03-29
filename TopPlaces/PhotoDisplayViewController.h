//
//  PhotoViewController.h
//  TopPlaces
//
//  Created by Zhan Jingjie on 8/3/12.
//  Copyright (c) 2012 Zhan Jingjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "splitViewBarButtonPresenter.h"

// A generic photo displaying view controller
// Will display photo in a scroll view, photo can be scrolled, zoomed
@interface PhotoDisplayViewController : UIViewController <UISplitViewControllerDelegate, splitViewBarButtonPresenter>
// A URL that connects to a photo
@property (nonatomic, strong) NSURL *photoURL;
@end
