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


@interface TopPlacesViewController()

typedef enum {
	SortPlacesByCountryName = 1,
	SortPlacesByCityName = 2
} SortingOptions;

@end



@implementation TopPlacesViewController


/*
 Sort the places in alphabetical order
 */
- (NSArray *)SortArray: (NSArray *)tmp
			   ByOrder: (SortingOptions)option
{
	NSArray *sortedArray = [NSArray array];
	
	// Sort the one-dimensional array by option
	switch (option) {
		case SortPlacesByCountryName:
			sortedArray = [tmp sortedArrayUsingComparator: ^(id obj1, id obj2) {
				NSString *country1 = [[[obj1 objectForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] lastObject];
				NSString *country2 = [[[obj2 objectForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] lastObject];
				return [country1 compare:country2];
			}];
			break;
		case SortPlacesByCityName:
			sortedArray = [tmp sortedArrayUsingComparator: ^(id obj1, id obj2) {
				NSString *city1 = [[[obj1 objectForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] objectAtIndex:0];
				NSString *city2 = [[[obj2 objectForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] objectAtIndex:0];
				return [city1 compare:city2];
			}];
			break;
		default:
			break;
	}
	
	return sortedArray;
}

// Output: a double array, sorted by country and by city
- (NSArray *)loadByCountryOrder
{
	NSArray *tmp = [FlickrFetcher topPlaces];
	NSArray *arraySortedByCountry = [self SortArray:tmp ByOrder:SortPlacesByCountryName];
	
	// This will be an array of array, each subarray is a country
	NSMutableArray *sorted = [NSMutableArray array];
	
	int i = 1;
	int num = 1;
	while (i < [arraySortedByCountry count]) {
		NSString *country1 = [[[[arraySortedByCountry objectAtIndex:i] objectForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] lastObject];
		NSString *country2 = [[[[arraySortedByCountry objectAtIndex:i-1] objectForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] lastObject];
		if ([country1 isEqualToString:country2]) {
			num++;
			i++;
			continue;
		}
		// let i-num is the starting point of the same dictionaries, and we have num number of same dics
		NSArray *oneCountry = [arraySortedByCountry subarrayWithRange:NSMakeRange(i-num, num)];
		[sorted addObject:oneCountry];
		
		num=1;
		i++;
	}
	
	return sorted;
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
	self.objects = [self SortArray:[FlickrFetcher topPlaces] ByOrder:SortPlacesByCountryName];
}


- (void)viewWillAppear:(BOOL)animated
{
	NSArray *tmp = self.objects;
	[super viewWillAppear:animated];
	self.objects = tmp;
}




#pragma mark - Table view data source

// Divides the list by contries, and the countries are in alphabetical order
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





