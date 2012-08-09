//
//  RecentPlacesViewController.m
//  TopPlaces
//
//  Created by Zhan Jingjie on 8/3/12.
//  Copyright (c) 2012 Zhan Jingjie. All rights reserved.
//

#import "RecentPlacesViewController.h"
#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@interface RecentPlacesViewController ()

@end

@implementation RecentPlacesViewController

@synthesize recentPhotos = _recentPhotos;

#define RECENT_PHOTOS @"recent photos"
#define PHOTO_TITLE @"title"

// Both viewDidLoad and viewWillAppear get called when switch between tab bars
- (void)viewDidLoad
{
    [super viewDidLoad];
}

// All other methods can be reused except this one
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:NO];
	NSArray *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_PHOTOS];
	if (_recentPhotos != tmp) {
		self.recentPhotos = tmp;
		// Maybe later can only reload or insert delete part of the date instead of reload all
		if (self.tableView.window) [self.tableView reloadData];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Show One Photo"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSDictionary *photoInfo = [self.recentPhotos objectAtIndex:indexPath.row];
		
		// Set the destination view controller's title as the image's title
		((PhotoViewController *)segue.destinationViewController).title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
		
		// Pass the URL to the destination view controller
		// The destination view controller should be a generic image displaying controller, display the image from the URL
		NSURL *photoURL = [FlickrFetcher urlForPhoto:photoInfo format:FlickrPhotoFormatLarge];
		((PhotoViewController *)segue.destinationViewController).photoURL = photoURL;
	}
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recentPhotos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recent Photos Pool";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	
    // Configure the cell...
	NSDictionary *photoDescription = [self.recentPhotos objectAtIndex:indexPath.row];
	
	// Get the content for the cell's title and subtitle
	NSString *title = [[photoDescription objectForKey:PHOTO_TITLE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *description = [[photoDescription valueForKeyPath:@"description._content"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	cell.textLabel.text = [title length] ? title : ([description length] ? description : @"Unknown");
	cell.detailTextLabel.text = description;

    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
