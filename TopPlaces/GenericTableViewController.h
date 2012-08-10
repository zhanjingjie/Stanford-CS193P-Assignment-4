//
//  RecentPlacesViewController.h
//  TopPlaces
//
//  Created by Zhan Jingjie on 8/3/12.
//  Copyright (c) 2012 Zhan Jingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenericTableViewController : UITableViewController
// Model is an array of photos info (dictionary), subclass can also have an array of places
@property (nonatomic, strong) NSArray *objects; // The model
@end
