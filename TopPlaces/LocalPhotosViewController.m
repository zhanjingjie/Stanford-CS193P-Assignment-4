//
//  LocalPhotosViewController.m
//  TopPlaces
//
//  Created by Zhan Jingjie on 8/2/12.
//  Copyright (c) 2012 Zhan Jingjie. All rights reserved.
//

#import "LocalPhotosViewController.h"
#import "PhotoDisplayViewController.h"
#import "FlickrFetcher.h"


@implementation LocalPhotosViewController

@synthesize place = _place;

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.objects = [FlickrFetcher photosInPlace:self.place maxResults:MAX_PHOTO_NUMBER];
}

// The parent method will change the variable, so has to save it back
- (void)viewWillAppear:(BOOL)animated
{
	/*
	NSArray *tmp = self.objects;
	[super viewWillAppear:animated];
	self.objects = tmp;
	 */
}



#pragma mark - Table view delegate

// Return true if the photo already exist (a duplicate)
- (BOOL)checkIfPhoto:(NSDictionary *)photoInfo
	  existInRecents:(NSArray *)photoArray
{
	NSString *photoID = [photoInfo objectForKey:FLICKR_PHOTO_ID];
	for (NSDictionary *dictionary in photoArray) {
		if ([[dictionary objectForKey:FLICKR_PHOTO_ID] isEqualToString:photoID]) {
			return YES;
		}
	}
	return NO;
}


- (id <splitViewBarButtonPresenter>)splitViewBarButtonPresenter
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	if ([self splitViewBarButtonPresenter]) {
		id detailVC = [self splitViewBarButtonPresenter];
		if ([detailVC isKindOfClass:[PhotoDisplayViewController class]]) {
			PhotoDisplayViewController *detailViewController = (PhotoDisplayViewController *)detailVC;
			detailViewController.title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
			NSDictionary *photoInfo = [self.objects objectAtIndex:indexPath.row];
			NSURL *photoURL = [FlickrFetcher urlForPhoto:photoInfo format:FlickrPhotoFormatLarge];
			detailViewController.photoURL = photoURL;
		}
	}
	
	// Get the dictionary
	NSDictionary *photoInfo = [self.objects objectAtIndex:indexPath.row];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *tmp = [defaults objectForKey:FLICKR_RECENT_PHOTOS] ? [[defaults objectForKey:FLICKR_RECENT_PHOTOS] mutableCopy] : [NSMutableArray array];
	
	if (![self checkIfPhoto:photoInfo existInRecents:tmp]) {
		if ([tmp count] == MAX_RECENTS) {
			[tmp removeObjectAtIndex:0];
		}
		[tmp addObject:photoInfo];
	}
	[defaults setObject:tmp forKey:FLICKR_RECENT_PHOTOS];
	[defaults synchronize];
	
}

@end
