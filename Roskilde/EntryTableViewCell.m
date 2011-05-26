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


@interface EntryTableViewCell ()
- (CGPathRef)renderPaperCurl:(CGSize)size;
@end


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

- (CGPathRef)renderPaperCurl:(CGSize)size {
	CGFloat insetSize = 5.0;
	CGFloat shadowDepth = 5.0f;
	
	UIBezierPath *path = [UIBezierPath bezierPath];
	[path moveToPoint:CGPointMake(insetSize, size.height)];
	[path addLineToPoint:CGPointMake(size.width - insetSize, size.height)];
	[path addLineToPoint:CGPointMake(size.width - insetSize, size.height + shadowDepth)];
	[path addLineToPoint:CGPointMake(size.width/2.0, size.height)];
	[path addLineToPoint:CGPointMake(insetSize, size.height + shadowDepth)];
	
	return path.CGPath;
}

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
	CGFloat y = 300.0;
		
	//	_highlighted ? [[UIColor lightGrayColor] set] : [[UIColor lightGrayColor] set];
	[[UIColor colorWithRed:0.878 green:0.846 blue:0.800 alpha:1.000] set];
	
	if (![self.location isEqualToString:@""]) {
		[self.author drawInRect:CGRectMake(50.0, 4.0, 200.0, 20.0)
					   withFont:timeFont];
	}
	else {
		[self.author drawInRect:CGRectMake(50.0, 10.0, 200.0, 20.0)
					   withFont:timeFont];
	}
	
	[self.location drawInRect:CGRectMake(50.0, 16.0, 200.0, 20.0)
				withFont:infoFont];
	
	NSString *dateString	= [creationDate formattedExactRelativeShortDate];
	
	CGSize size = [dateString sizeWithFont:timeFont
						 constrainedToSize:CGSizeMake(FLT_MAX, 20.0)
							 lineBreakMode:UILineBreakModeTailTruncation];
	
	UIImage *clock = [UIImage imageNamed:@"time_icon.png"];
	[clock drawAtPoint:CGPointMake(y - clock.size.width - 4.0 - size.width, 10.0)];
	
	[dateString drawInRect:CGRectMake(y - size.width, 10.0, size.width, size.height)
				  withFont:timeFont];
	
	
	
	y = imageHeight + kAuthorBarHeight + 3.0;
	
	[[UIColor colorWithRed:0.651 green:0.651 blue:0.651 alpha:1.000] set];
	
	UIImage *bottom = [UIImage imageNamed:@"picture_bottom.png"];
	[bottom drawAtPoint:CGPointMake(kPadding, y)];
	
	
//	if (self.imageReplies > 0) {
		y += 8;
		[imageRepliesIcon drawAtPoint:CGPointMake(kPadding + 10, y)];
		CGSize imageRepliesSize = [self infoSize:imageReplies];
		[int2str(imageReplies) drawInRect:CGRectMake(kPadding + 12 + kIconSpaceX + imageRepliesIcon.size.width, y+kIconSpaceY,
													 imageRepliesSize.width, imageRepliesSize.height)
								 withFont:infoFont];
//	}
	
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
	
	self.avatarView = [[[FLImageView alloc] initWithFrame:CGRectMake(kPadding, 6.0, size.width, size.height)] autorelease];
	
	[self addSubview:self.avatarView];
	
	UIImage * placeholder = [UIImage imageNamed:@"miniavatar.png"];
	NSString *urlString = [NSString stringWithFormat:@"%@=s%.f-c", url, size.width * placeholder.scale];
	[self.avatarView loadImageAtURLString:urlString placeholderImage:placeholder];
}

- (void)setImageUrl:(NSString*)url
			   size:(CGSize)size {
	
	if (self.imageView) {
		[self.imageView removeFromSuperview];

		self.imageView.image = nil;
		self.imageView = nil;
	}
	
	imageHeight = size.height;
	
	self.imageView = [[[FLImageView alloc] initWithFrame:CGRectMake(kPadding, kAuthorBarHeight + 4.0, size.width, size.height)] autorelease];
//	self.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
//	self.imageView.layer.shadowOpacity = 0.5f;
//	self.imageView.layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
//	self.imageView.layer.shadowRadius = 0.8f;
//	self.imageView.layer.masksToBounds = NO;
//	self.imageView.layer.shadowPath = [self renderPaperCurl:imageView.bounds.size];
	
	[self addSubview:self.imageView];
	
	UIImage * placeholder = [UIImage imageNamed:@"xbg.png"];
	NSString *urlString = [NSString stringWithFormat:@"%@=s%.f", url, size.width * placeholder.scale];
	[self.imageView loadImageAtURLString:urlString placeholderImage:placeholder];
}

@end
