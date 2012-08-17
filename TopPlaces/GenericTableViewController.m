//
//  GenericTableViewController.m
//  This class will be the parent of all other similar classes.
//  TopPlaces
//
//  Created by Zhan Jingjie on 8/3/12.
//  Copyright (c) 2012 Zhan Jingjie. All rights reserved.
//

#import "GenericTableViewController.h"
#import "PhotoDisplayViewController.h"
#import "FlickrFetcher.h"
#import "Constants.h"


@implementation GenericTableViewController

@synthesize objects = _objects;

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	NSArray *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_PHOTOS];
	if (_objects != tmp) {
		self.objects = tmp;
		if (self.tableView.window) [self.tableView reloadData];
	}
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Show Photo"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSDictionary *photoInfo = [self.objects objectAtIndex:indexPath.row];
		
		// Set the destination view controller's title as the image's title
		((PhotoDisplayViewController *)segue.destinationViewController).title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
		NSURL *photoURL = [FlickrFetcher urlForPhoto:photoInfo format:FlickrPhotoFormatLarge];
		((PhotoDisplayViewController *)segue.destinationViewController).photoURL = photoURL;
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Reusable Pool";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	
	// This is a dictionary containing photo info, same for LocalPhotosViewController
	NSDictionary *objectDescription = [self.objects objectAtIndex:indexPath.row];
	
	// Get the content for the cell's title and subtitle
	NSString *title = [[objectDescription objectForKey:PHOTO_TITLE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *description = [[objectDescription valueForKeyPath:@"description._content"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	cell.textLabel.text = [title length] ? title : ([description length] ? description : @"Unknown");
	cell.detailTextLabel.text = description;
	
	// Now the code is lagging, when loaded and scrolled
	// See Apple LazyTableImage sample project for more info
	NSURL *photoURL = [FlickrFetcher urlForPhoto:objectDescription format:FlickrPhotoFormatSquare];
	cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
	
	
	/*
	 dispatch_queue_t downloadImages = dispatch_queue_create("download images", NULL);
	 dispatch_async(downloadImages, ^{
	 NSData *data = [NSData dataWithContentsOfURL:photoURL];
	 dispatch_async(dispatch_get_main_queue(), ^{
	 UIImage *raw = [UIImage imageWithData:data];
	 cell.imageView.image = [self imageWithImage:raw convertToSize:CGSizeMake(THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT)];
	 });
	 });
	 dispatch_release(downloadImages);
	 */
	
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
