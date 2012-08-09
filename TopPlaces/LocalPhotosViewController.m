//
//  LocalPhotosViewController.m
//  TopPlaces
//
//  Created by Zhan Jingjie on 8/2/12.
//  Copyright (c) 2012 Zhan Jingjie. All rights reserved.
//

#import "LocalPhotosViewController.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"

@interface LocalPhotosViewController ()
@property (nonatomic, strong) NSArray *allPhotos;
@end

@implementation LocalPhotosViewController

@synthesize thePlace = _thePlace;
@synthesize allPhotos = _allPhotos;

#define MAX_PHOTO_NUMBER 50

- (IBAction)refresh:(id)sender {
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[spinner startAnimating];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
	
	dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
	dispatch_async(downloadQueue, ^{
		NSArray *tmp = [FlickrFetcher photosInPlace:self.thePlace maxResults:MAX_PHOTO_NUMBER];
		dispatch_async(dispatch_get_main_queue(), ^{
			self.navigationItem.rightBarButtonItem = sender;
			self.allPhotos = tmp;
		});
	});
	dispatch_release(downloadQueue);
	NSLog(@"Refresh the top photos list.");
}

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
	self.allPhotos = [FlickrFetcher photosInPlace:self.thePlace maxResults:MAX_PHOTO_NUMBER];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Show One Photo"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSDictionary *photoInfo = [self.allPhotos objectAtIndex:indexPath.row];
		
		// Set the destination view controller's title as the image's title
		((PhotoViewController *)segue.destinationViewController).title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;

		// Pass the URL to the destination view controller
		// The destination view controller should be a generic image displaying controller, display the image from the URL
		NSURL *photoURL = [FlickrFetcher urlForPhoto:photoInfo format:FlickrPhotoFormatLarge];
		((PhotoViewController *)segue.destinationViewController).photoURL = photoURL;
	}
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
#define THUMBNAIL_WIDTH 50
#define THUMBNAIL_HEIGHT 50


- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}


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
	//NSURL *photoURL = [FlickrFetcher urlForPhoto:photoDescription format:FlickrPhotoFormatThumbnail];
	
	cell.textLabel.text = [title length] ? title : ([description length] ? description : @"Unknown");
	cell.detailTextLabel.text = description;
	
	// Now the code is lagging, when loaded and scrolled
	// See Apple LazyTableImage sample project for more info
	/*
	UIImage *raw = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
	cell.imageView.image = [self imageWithImage:raw convertToSize:CGSizeMake(THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT)];
	*/
	
	// The behavior is strange: images only show after you scroll the first time, but no lagging now
	// Will worry about performance later
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
