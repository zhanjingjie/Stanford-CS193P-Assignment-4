//
//  TopPlacesViewController.m
//  TopPlaces
//
//  Created by Zhan Jingjie on 8/2/12.
//  Copyright (c) 2012 Zhan Jingjie. All rights reserved.
//

#import "TopPlacesViewController.h"
#import "LocalPhotosViewController.h"
#import "FlickrFetcher.h"

@implementation TopPlacesViewController

/*
 Helper method to return the places in alphabetical order in an array
 */
- (NSArray *)loadPlacesInOrder
{
	NSArray *tmp = [FlickrFetcher topPlaces];
	NSArray *sortedArray = [tmp sortedArrayUsingComparator: ^(id obj1, id obj2) {
		NSString *city1 = [[[obj1 objectForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] objectAtIndex:0];
		NSString *city2 = [[[obj2 objectForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] objectAtIndex:0];
		return [city1 compare:city2];
	}];
	return sortedArray;
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Show Photo Descriptions"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSDictionary *place = [self.objects objectAtIndex:indexPath.row];
		
		((LocalPhotosViewController *)segue.destinationViewController).title = [[[place objectForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] objectAtIndex:0];
		((LocalPhotosViewController *) segue.destinationViewController).place = place;
	}
}






#pragma mark - View Life Cycle


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.objects = [self loadPlacesInOrder];
}


- (void)viewWillAppear:(BOOL)animated
{
	NSArray *tmp = self.objects;
	[super viewWillAppear:animated];
	self.objects = tmp;
}




#pragma mark - Table view data source

// Make it no section first
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}
*/


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Reusable Pool";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	
    // Configure the cell...
	NSDictionary *place = [self.objects objectAtIndex:indexPath.row];
	NSString *placeName = [place objectForKey:FLICKR_PLACE_NAME];
	NSArray *list = [placeName componentsSeparatedByString:@", "];
	
	cell.textLabel.text = [list objectAtIndex:0];
	if ([list count] == 3) {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", [list objectAtIndex:1], [list objectAtIndex:2]];
	} else {
		cell.detailTextLabel.text = [list objectAtIndex:1];
	}
    
    return cell;
}





@end





