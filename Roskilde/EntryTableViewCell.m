//
//  EntryTableViewCell.m
//  XKamera
//
//  Created by Willi Wu on 20/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EntryTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#import "NSDateHelper.h"



#define kInfoFontSize		12.0
#define kInfoMaxWidth		40.0
#define kInfoMaxHeight		14.0
#define kIconSpaceX			4.0
#define kIconSpaceY			2.0

#define kAuthorBarHeight	30.0

#define kPadding			20.0

#define int2str(value)	([[[NSString alloc] initWithFormat:@"%d", value] autorelease])



@implementation EntryTableViewCell


@synthesize imageReplies;
@synthesize views;
@synthesize replies;
@synthesize likes;
@synthesize author;
@synthesize location;
@synthesize creationDate;
@synthesize avatarView;
@synthesize imageView;
@synthesize imageHeight;
@synthesize target, action;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		imageRepliesIcon = [[UIImage imageNamed:@"rebound_icon.png"] retain];
		viewsIcon = [[UIImage imageNamed:@"viewcount_icon.png"] retain];
		repliesIcon = [[UIImage imageNamed:@"comment_icon.png"] retain];
		likesIcon = [[UIImage imageNamed:@"like_icon.png"] retain];
	}
    return self;
}

- (void)dealloc
{
	self.author = nil;
    self.location = nil;
    self.creationDate = nil;
    self.avatarView = nil;
    self.imageView = nil;
	
    [super dealloc];
}


//- (void) willMoveToSuperview:(UIView *)newSuperview {
//	[super willMoveToSuperview:newSuperview];
//	
//	if(!newSuperview) {
//		[self.imageView cancelCurrentImageLoad];
//	}
//}


- (CGSize)infoSize:(NSInteger)value
{
	UIFont * infoFont	= [UIFont systemFontOfSize:kInfoFontSize];
	
	NSString *valueString = int2str(value);
	CGSize size = [valueString sizeWithFont:infoFont
						  constrainedToSize:CGSizeMake(kInfoMaxWidth, kInfoMaxHeight)
							  lineBreakMode:UILineBreakModeTailTruncation];
	
	return size;
}

- (void)drawContentView:(CGRect)rect
{
	// Subclasses should implement this
	
	UIFont *timeFont		= [UIFont boldSystemFontOfSize:12];
	UIFont * infoFont	= [UIFont systemFontOfSize:kInfoFontSize];
	CGFloat x = 320.0 - kPadding;
	CGFloat y = 24.0;
		
	//	_highlighted ? [[UIColor lightGrayColor] set] : [[UIColor lightGrayColor] set];
	[[UIColor colorWithRed:0.878 green:0.846 blue:0.800 alpha:1.000] set];
	
	if (![self.location isEqualToString:@""]) {
		[self.author drawInRect:CGRectMake(50.0, y, 200.0, 20.0)
					   withFont:timeFont];
		
		UIImage *loc = [UIImage imageNamed:@"tinylocation.png"];
		[loc drawAtPoint:CGPointMake(50.0, y+15.0)];
	}
	else {
		[self.author drawInRect:CGRectMake(50.0, y+6.0, 200.0, 20.0)
					   withFont:timeFont];
	}
	
	[[UIColor colorWithWhite:0.710 alpha:1.000] set];
		
	[self.location drawInRect:CGRectMake(60.0, y+12.0, 200.0, 20.0)
				withFont:infoFont];
	
	NSString *dateString	= [creationDate formattedExactRelativeShortDate];
	
	CGSize size = [dateString sizeWithFont:timeFont
						 constrainedToSize:CGSizeMake(FLT_MAX, 20.0)
							 lineBreakMode:UILineBreakModeTailTruncation];
	
	UIImage *clock = [UIImage imageNamed:@"time_icon_grey.png"];
	[clock drawAtPoint:CGPointMake(x - clock.size.width - 4.0 - size.width, y+6.0)];
	
	[dateString drawInRect:CGRectMake(x - size.width, y+6.0, size.width, size.height)
				  withFont:timeFont];
	
	
	
	y = imageHeight + kAuthorBarHeight + 24.0;
	
	[[UIColor colorWithRed:0.651 green:0.651 blue:0.651 alpha:1.000] set];
	
	UIImage *bottom = [UIImage imageNamed:@"picture_bottom.png"];
	[bottom drawAtPoint:CGPointMake(kPadding, y)];
	
	y += 8;
	
	if (self.imageReplies > 0) {
		[imageRepliesIcon drawAtPoint:CGPointMake(kPadding + 10, y)];
		CGSize imageRepliesSize = [self infoSize:imageReplies];
		[int2str(imageReplies) drawInRect:CGRectMake(kPadding + 12 + kIconSpaceX + imageRepliesIcon.size.width, y+kIconSpaceY,
													 imageRepliesSize.width, imageRepliesSize.height)
								 withFont:infoFont];
	}
	
	CGSize likesSize = [self infoSize:likes];
	x -= kIconSpaceX + likesIcon.size.width + likesSize.width + 10.0;
	CGFloat textY = y + 1;
	[likesIcon drawAtPoint:CGPointMake(x, y+2)];
	[int2str(likes) drawInRect:CGRectMake(x + kIconSpaceX + likesIcon.size.width, textY,
										  likesSize.width, likesSize.height)
					  withFont:infoFont];
	
	CGSize repliesSize = [self infoSize:replies];
	x -= kIconSpaceX + repliesIcon.size.width + repliesSize.width + 10.0;
	[repliesIcon drawAtPoint:CGPointMake(x, y+1)];
	[int2str(replies) drawInRect:CGRectMake(x + kIconSpaceX + repliesIcon.size.width, textY,
											repliesSize.width, repliesSize.height)
						withFont:infoFont];
	
	CGSize viewsSize = [self infoSize:views];
	x -= kIconSpaceX + viewsIcon.size.width + viewsSize.width + 10.0;
	[viewsIcon drawAtPoint:CGPointMake(x, y+2)];
	[int2str(views) drawInRect:CGRectMake(x + kIconSpaceX + viewsIcon.size.width, textY,
												 viewsSize.width, viewsSize.height)
							 withFont:infoFont];
}


- (void)setAvatarUrl:(NSString*)url
			   size:(CGSize)size {
	
	if (self.avatarView) {
		[self.avatarView removeFromSuperview];
		
		self.avatarView.image = nil;
		self.avatarView = nil;
	}
	
	self.avatarView = [[[FLImageView alloc] initWithFrame:CGRectMake(kPadding, 26.0, size.width, size.height)] autorelease];
	
	[self addSubview:self.avatarView];
	
	UIImage * placeholder = [UIImage imageNamed:@"miniavatar.png"];
	NSString *urlString = [NSString stringWithFormat:@"%@=s%.f-c", url, size.width * placeholder.scale];
	[self.avatarView loadImageAtURLString:urlString placeholderImage:placeholder];
}

- (void)setImageUrl:(NSString*)url
			   size:(CGSize)size
			 dlsize:(CGSize)dlsize {
	
	if (self.imageView) {
		[self.imageView removeFromSuperview];

		self.imageView.image = nil;
		self.imageView = nil;
	}
	
	imageHeight = size.height;
	
	self.imageView = [[[FLImageView alloc] initWithFrame:CGRectMake(kPadding, kAuthorBarHeight + 24.0, size.width, size.height)] autorelease];
	self.imageView.contentMode = UIViewContentModeScaleAspectFill;
	self.imageView.clipsToBounds = YES;
	
	CGFloat scale = ([[UIScreen mainScreen] respondsToSelector:@selector (scale)] ? [[UIScreen mainScreen] scale] : 1);
	
	[self addSubview:self.imageView];
	
	float maxsize = round(MAX(dlsize.width, dlsize.height));
	
	UIImage * placeholder = [UIImage imageNamed:@"loaderbg.png"];
	NSString *urlString = [NSString stringWithFormat:@"%@=s%.f", url, maxsize * scale];
	
	[self.imageView loadImageAtURLString:urlString placeholderImage:placeholder];
}

@end
