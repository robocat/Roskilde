//
//  ReplyTableViewCell.m
//  Roskilde
//
//  Created by Willi Wu on 30/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReplyTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#import "NSDateHelper.h"



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



@implementation ReplyTableViewCell


@synthesize imageReplies;
@synthesize author;
@synthesize creationDate;
@synthesize comment;
@synthesize avatarView;
@synthesize imageView;
@synthesize imageHeight;
@synthesize target, action;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
	}
    return self;
}

- (void)dealloc
{
	self.author = nil;
    self.creationDate = nil;
	self.comment = nil;
    self.avatarView = nil;
    self.imageView = nil;
	
    [super dealloc];
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
	
	// Author
	
	CGFloat x = 310.0;
	CGFloat y = 0.0;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
	
	[[UIColor colorWithRed:0.878 green:0.846 blue:0.800 alpha:1.000] setFill];
	CGRect commentRect = CGRectMake(0.0, y, 320.0, kAuthMinHieght);
	CGContextFillRect( context , commentRect );
	
	UIFont *timeFont		= [UIFont boldSystemFontOfSize:12];
	
	[[UIColor darkGrayColor] set];
	
	[self.author drawInRect:CGRectMake(60.0, y+10.0, 200.0, 20.0)
				   withFont:timeFont];
	
	[[UIColor colorWithWhite:0.710 alpha:1.000] set];
	
	NSString *dateString	= [creationDate formattedExactRelativeShortDate];
	
	CGSize size = [dateString sizeWithFont:timeFont
						 constrainedToSize:CGSizeMake(FLT_MAX, 20.0)
							 lineBreakMode:UILineBreakModeTailTruncation];
	
	UIImage *clock = [UIImage imageNamed:@"time_icon_grey.png"];
	[clock drawAtPoint:CGPointMake(x - clock.size.width - 4.0 - size.width, 10.0)];
	
	[dateString drawInRect:CGRectMake(x - size.width, 10.0, size.width, size.height)
				  withFont:timeFont];
	
	
	// Comment
	
	if (![self.comment isEqualToString:@""]) {
		[[UIColor blackColor] set];
		
		CGSize commentSize = [self.comment sizeWithFont:timeFont
									  constrainedToSize:CGSizeMake(200.0f, FLT_MAX)
										  lineBreakMode:UILineBreakModeTailTruncation];
		
		[self.comment drawInRect:CGRectMake(60.0, y+kStatsBarHieght, commentSize.width, commentSize.height)
						withFont:timeFont];
	}
	
	
	// Separator
//	CGRect frame = self.frame;
//	
//	CGContextSetStrokeColor(context, CGColorGetComponents([[UIColor  lightGrayColor] CGColor]));
//	CGContextBeginPath(context);
//	CGContextMoveToPoint(context, 0.0, frame.size.height -2);
//	CGContextAddLineToPoint(context, frame.size.width, frame.size.height -2);
//	CGContextStrokePath(context);
//	CGContextMoveToPoint(context, 0.0, frame.size.height);
//	// shadow
//	CGContextSetStrokeColor(context, CGColorGetComponents([[UIColor  whiteColor] CGColor]));
//	CGContextBeginPath(context);
//	CGContextMoveToPoint(context, 0.0, frame.size.height-1);
//	CGContextAddLineToPoint(context, frame.size.width, frame.size.height-1);
//	CGContextStrokePath(context);
	
	CGContextRestoreGState(context);
}


- (void)setAvatarUrl:(NSString*)url
				size:(CGSize)size {
	
	if (self.avatarView) {
		[self.avatarView removeFromSuperview];
		
		self.avatarView.image = nil;
		self.avatarView = nil;
	}
	
	self.avatarView = [[[FLImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, size.width, size.height)] autorelease];
	
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
	
	UIImage * placeholder = [UIImage imageNamed:@"xbg.png"];
	NSString *urlString = [NSString stringWithFormat:@"%@=s%.f", url, maxsize * scale];
	
	[self.imageView loadImageAtURLString:urlString placeholderImage:placeholder];
}

@end
