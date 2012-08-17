//
//  FlickrFetcher.h
//
//  Created for Stanford CS193p Fall 2011.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FLICKR_PHOTO_TITLE @"title"
#define FLICKR_PHOTO_DESCRIPTION @"description._content"
#define FLICKR_PLACE_NAME @"_content"
#define FLICKR_PHOTO_ID @"id"
#define FLICKR_PHOTO_OWNER @"ownername"
#define FLICKR_LATITUDE @"latitude"
#define FLICKR_LONGITUDE @"longitude"
#define FLICKR_RECENT_PHOTOS @"recent photos"
extern int const MAX_PHOTO_NUMBER;
extern int const MAX_RECENTS;


typedef enum {
	FlickrPhotoFormatSquare = 1,
	FlickrPhotoFormatLarge = 2,
	FlickrPhotoFormatThumbnail = 3,
	FlickrPhotoFormatOriginal = 64
} FlickrPhotoFormat;

@interface FlickrFetcher : NSObject

+ (NSArray *)topPlaces;
+ (NSArray *)photosInPlace:(NSDictionary *)place maxResults:(int)maxResults;
+ (NSURL *)urlForPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format;

@end
