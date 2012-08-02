//
//  TopPlacesViewController.m
//  TopPlaces
//
//  Created by Zhan Jingjie on 8/2/12.
//  Copyright (c) 2012 Zhan Jingjie. All rights reserved.
//

#import "TopPlacesViewController.h"
#import "FlickrFetcher.h"

@interface TopPlacesViewController ()

@end

@implementation TopPlacesViewController

@synthesize topPlaces = _topPlaces;


#define PLACE_NAME_KEY @"_content"

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


- (IBAction)refresh:(id)sender {
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[spinner startAnimating];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
	
	dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
	dispatch_async(downloadQueue, ^{
		NSArray *tmp = [self loadPlacesInOrder];
		dispatch_async(dispatch_get_main_queue(), ^{
			self.navigationItem.rightBarButtonItem = sender;
			self.topPlaces = tmp;
		});
	});
	dispatch_release(downloadQueue);
	NSLog(@"Refresh the top places list.");
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
	self.topPlaces = [self loadPlacesInOrder];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
