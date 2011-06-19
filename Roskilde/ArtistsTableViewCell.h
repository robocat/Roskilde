//
//  ArtistsTableViewCell.h
//  Roskilde
//
//  Created by Willi Wu on 18/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RKTableViewCell.h"


@interface ArtistsTableViewCell : RKTableViewCell {
	NSString	*artistId;
	NSString	*name;
	NSString	*timeScene;
	BOOL		isFavorite;
	
	UIImageView *imageView;
}

@property (nonatomic, retain) NSString *artistId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *timeScene;
@property (nonatomic, assign, getter=isFavorite) BOOL isFavorite;
@property (nonatomic, retain) UIImageView *imageView;

@end
