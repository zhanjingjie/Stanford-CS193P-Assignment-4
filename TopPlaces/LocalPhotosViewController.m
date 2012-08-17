//
//  LocalPhotosViewController.m
//  TopPlaces
//
//  Created by Zhan Jingjie on 8/2/12.
//  Copyright (c) 2012 Zhan Jingjie. All rights reserved.
//

#import "LocalPhotosViewController.h"
#import "PhotoDisplayViewController.h"
#import "Constants.h"
#import "FlickrFetcher.h"


@implementation LocalPhotosViewController

@synthesize place = _place;


// Need to override the parent variable objects
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:NO];
	self.objects = [FlickrFetcher photosInPlace:self.place maxResults:MAX_PHOTO_NUMBER];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Show Photo"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSDictionary *photoInfo = [self.objects objectAtIndex:indexPath.row];
		
		// Set the destination view controller's title as the image's title
		((PhotoDisplayViewController *)segue.destinationViewController).title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;

		// Pass the URL to the destination view controller
		// The destination view controller should be a generic image displaying controller, display the image from the URL
		NSURL *photoURL = [FlickrFetcher urlForPhoto:photoInfo format:FlickrPhotoFormatLarge];
		((PhotoDisplayViewController *)segue.destinationViewController).photoURL = photoURL;
	}
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.objects count];
}


// Somehow this method use the model in the parent class
// Or maybe the prepareForSegue in the TopPlacesViewController set the Local's model as its parent

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"All Photos Pool";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	
    // Configure the cell...
	NSDictionary *photoDescription = [self.objects objectAtIndex:indexPath.row];
	
	// Get the content for the cell's title and subtitle
	NSString *title = [[photoDescription objectForKey:PHOTO_TITLE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *description = [[photoDescription valueForKeyPath:@"description._content"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	cell.textLabel.text = [title length] ? title : ([description length] ? description : @"Unknown");
	cell.detailTextLabel.text = description;
	
	// Now the code is lagging, when loaded and scrolled
	// See Apple LazyTableImage sample project for more info
	/*
	NSURL *photoURL = [FlickrFetcher urlForPhoto:photoDescription format:FlickrPhotoFormatSquare];
	cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
	*/
	
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

// Return true if the photo already exist (a duplicate)
- (BOOL)checkIfPhoto:(NSDictionary *)photoInfo
	  existInRecents:(NSArray *)photoArray
{
	NSString *photoID = [photoInfo objectForKey:PHOTO_ID];
	for (NSDictionary *dictionary in photoArray) {
		if ([[dictionary objectForKey:PHOTO_ID] isEqualToString:photoID]) {
			return YES;
		}
	}
	return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	// Get the dictionary
	NSDictionary *photoInfo = [self.objects objectAtIndex:indexPath.row];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *tmp = [defaults objectForKey:RECENT_PHOTOS] ? [[defaults objectForKey:RECENT_PHOTOS] mutableCopy] : [NSMutableArray array];
	
	if (![self checkIfPhoto:photoInfo existInRecents:tmp]) {
		if ([tmp count] == MAX_RECENTS) {
			[tmp removeObjectAtIndex:0];
		}
		[tmp addObject:photoInfo];
	}
	[defaults setObject:tmp forKey:RECENT_PHOTOS];
	[defaults synchronize];
	
}

@end
