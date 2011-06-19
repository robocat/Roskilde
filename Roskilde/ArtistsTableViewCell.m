//
//  ArtistsTableViewCell.m
//  Roskilde
//
//  Created by Willi Wu on 18/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ArtistsTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#import "NSDateHelper.h"
#import "UIImage+Resize.h"



#define kInfoFontSize		12.0
#define kInfoMaxWidth		40.0
#define kInfoMaxHeight		14.0
#define kIconSpaceX			4.0
#define kIconSpaceY			2.0

#define kAuthorBarHeight	30.0

#define kPadding			20.0


#define kStatsBarHieght		30.0
#define kAuthMinHieght		64.0

#define int2str(value)	([[[NSString alloc] initWithFormat:@"%d", value] autorelease])



@implementation ArtistsTableViewCell

@synthesize artistId;
@synthesize name;
@synthesize timeScene;
@synthesize isFavorite;
@synthesize imageView;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
	}
    return self;
}

- (void)dealloc
{
	[artistId release];
	[name release];
	[timeScene release];
	[imageView release];
	
    [super dealloc];
}


- (void)drawContentView:(CGRect)rect
{
	// Subclasses should implement this
	
	
	NSString *imageName = [NSString stringWithFormat:@"%@_small.jpg", self.artistId];
	UIImage *image = [UIImage imageNamed:imageName];
	[image drawAtPoint:CGPointMake(4.0, 4.0)];
	
	UIFont *artistFont = [UIFont boldSystemFontOfSize:16];
	UIFont *locFont = [UIFont boldSystemFontOfSize:14];
	
	// Artist
	[[UIColor blackColor] set];
	[self.name drawInRect:CGRectMake(60.0, 8.0, 230.0, 20.0)
				   withFont:artistFont];
	
	[[UIColor grayColor] set];
	
	[self.timeScene drawInRect:CGRectMake(60.0, 28.0, 260.0, 20.0)
				 withFont:locFont];
}

@end
