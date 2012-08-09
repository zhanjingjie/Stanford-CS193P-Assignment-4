//
//  RecentPlacesViewController.m
//  This class will be the parent of all similar classes
//  TopPlaces
//
//  Created by Zhan Jingjie on 8/3/12.
//  Copyright (c) 2012 Zhan Jingjie. All rights reserved.
//

#import "GenericTableViewController.h"
#import "PhotoDisplayViewController.h"
#import "FlickrFetcher.h"
#import "Constants.h"



@interface GenericTableViewController ()
@end



@implementation GenericTableViewController

@synthesize objects = _objects;


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:NO];
	NSArray *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_PHOTOS];
	if (_objects != tmp) {
		self.objects = tmp;
		// Maybe later can only reload or insert delete part of the date instead of reload all
		if (self.tableView.window) [self.tableView reloadData];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Show One Photo"]) {
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
    static NSString *CellIdentifier = @"Recent Photos Pool";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	
    // Configure the cell...
	NSDictionary *photoDescription = [self.objects objectAtIndex:indexPath.row];
	
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
