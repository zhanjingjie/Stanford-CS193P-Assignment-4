//
//  TopPlacesViewController.m
//  TopPlaces
//
//  Created by Zhan Jingjie on 8/2/12.
//  Copyright (c) 2012 Zhan Jingjie. All rights reserved.
//

#import "TopPlacesViewController.h"
#import "FlickrFetcher.h"
#import "LocalPhotosViewController.h"

@interface TopPlacesViewController ()

@end

@implementation TopPlacesViewController

@synthesize topPlaces = _topPlaces;


#define PLACE_NAME_KEY @"_content"
#define MAX_PHOTO_NUMBER 50

/*
 Helper method to return the places in alphabetical order in an array
 */
- (NSArray *)loadPlacesInOrder
{
	NSArray *tmp = [FlickrFetcher topPlaces];
	NSArray *sortedArray = [tmp sortedArrayUsingComparator: ^(id obj1, id obj2) {
		NSString *city1 = [[[obj1 objectForKey:PLACE_NAME_KEY] componentsSeparatedByString:@", "] objectAtIndex:0];
		NSString *city2 = [[[obj2 objectForKey:PLACE_NAME_KEY] componentsSeparatedByString:@", "] objectAtIndex:0];
		return [city1 compare:city2];
	}];
	return sortedArray;
}




// The better part of using this method is: you can customize the new table view controller in the interface builder instead of building from code.
// Not working well when I put the photosInPlace in a separate thread
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Show Photo Descriptions"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSDictionary *place = [self.topPlaces objectAtIndex:indexPath.row];
		
		// Maybe I should pass the place dictionary to the next controller
		NSArray *photos = [FlickrFetcher photosInPlace:place maxResults:MAX_PHOTO_NUMBER]; // This line might take the most time, make it in a separate thread
		// Set the destination view controller's title and the allPhotos property.
		((LocalPhotosViewController *)segue.destinationViewController).title = [[[place objectForKey:PLACE_NAME_KEY] componentsSeparatedByString:@", "] objectAtIndex:0];
		((LocalPhotosViewController *) segue.destinationViewController).allPhotos = photos;
	}
}






#pragma mark - View Life Cycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Show those top places when load
	self.topPlaces = [self loadPlacesInOrder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}



#pragma mark - Table view data source

// Make it no section first
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.topPlaces count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Places Pool";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	
    // Configure the cell...
	NSDictionary *place = [self.topPlaces objectAtIndex:indexPath.row];
	NSString *placeName = [place objectForKey:PLACE_NAME_KEY];
	NSArray *list = [placeName componentsSeparatedByString:@", "];
	
	cell.textLabel.text = [list objectAtIndex:0];
	if ([list count] == 3) {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", [list objectAtIndex:1], [list objectAtIndex:2]];
	} else {
		cell.detailTextLabel.text = [list objectAtIndex:1];
	}
    
    return cell;
}



#pragma mark - Table view delegate

// Should prepare the data for the next controller in prepareForSegue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}





@end





