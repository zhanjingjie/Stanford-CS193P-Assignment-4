//
//  LocalPhotosViewController.m
//  TopPlaces
//
//  Created by Zhan Jingjie on 8/2/12.
//  Copyright (c) 2012 Zhan Jingjie. All rights reserved.
//

#import "LocalPhotosViewController.h"

@interface LocalPhotosViewController ()

@end

@implementation LocalPhotosViewController

@synthesize allPhotos = _allPhotos;

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

// The default is no section
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}
*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.allPhotos count];
}

#define PHOTO_TITLE @"title"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"All Photos Pool";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	
    // Configure the cell...
	NSDictionary *photoDescription = [self.allPhotos objectAtIndex:indexPath.row];
	
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
}

@end