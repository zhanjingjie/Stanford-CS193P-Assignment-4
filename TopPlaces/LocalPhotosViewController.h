//
//  LocalPhotosViewController.h
//  TopPlaces
//
//  Created by Zhan Jingjie on 8/2/12.
//  Copyright (c) 2012 Zhan Jingjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericTableViewController.h"

@interface LocalPhotosViewController : GenericTableViewController
@property (nonatomic, strong) NSDictionary *place; // the model, a flickr photo dictionary
@end
