//
//  EntryTableViewCell.m
//  XKamera
//
//  Created by Willi Wu on 20/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EntryTableViewCell.h"
#import <QuartzCore/QuartzCore.h>


#define kInfoFontSize	12.0
#define kInfoMaxWidth	40.0
#define kInfoMaxHeight	14.0
#define kIconSpaceX		2.0
#define kIconSpaceY		1.0

#define kPadding		20.0

#define int2str(value)	([[[NSString alloc] initWithFormat:@"%d", value] autorelease])


@interface EntryTableViewCell ()
- (CGPathRef)renderPaperCurl:(CGSize)size;
@end


@implementation EntryTableViewCell

@synthesize imageReplies, views, replies, likes, imageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		imageRepliesIcon = [[UIImage imageNamed:@"rebound-icon.png"] retain];
		viewsIcon = [[UIImage imageNamed:@"view-icon.png"] retain];
		repliesIcon = [[UIImage imageNamed:@"comment-icon.png"] retain];
		likesIcon = [[UIImage imageNamed:@"likes-icon.png"] retain];
	}
    return self;
}

- (void)dealloc
{
	[imageView release];
	self.imageView = nil;
	
    [super dealloc];
}

- (CGPathRef)renderPaperCurl:(CGSize)size {
//	CGFloat curlFactor = 3.0f;
	CGFloat insetSize = 5.0;
	CGFloat shadowDepth = 5.0f;
	
	UIBezierPath *path = [UIBezierPath bezierPath];
	[path moveToPoint:CGPointMake(insetSize, size.height)];
	[path addLineToPoint:CGPointMake(size.width - insetSize, size.height)];
	[path addLineToPoint:CGPointMake(size.width - insetSize, size.height + shadowDepth)];
	[path addLineToPoint:CGPointMake(size.width/2.0, size.height)];
	[path addLineToPoint:CGPointMake(insetSize, size.height + shadowDepth)];
//	[path addCurveToPoint:CGPointMake(5.0, size.height + shadowDepth)
//			controlPoint1:CGPointMake(size.width - curlFactor, size.height + shadowDepth - curlFactor)
//			controlPoint2:CGPointMake(curlFactor, size.height + shadowDepth - curlFactor)];
	
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
	
	UIFont * infoFont	= [UIFont systemFontOfSize:kInfoFontSize];
	
	//	_highlighted ? [[UIColor lightGrayColor] set] : [[UIColor lightGrayColor] set];
	[[UIColor lightGrayColor] set];

	
	CGFloat x = 320.0 - kPadding;
	CGFloat y = imageHeight + kPadding;
		
//	if (self.imageReplies > 0) {
		[imageRepliesIcon drawAtPoint:CGPointMake(kPadding, y)];
		CGSize imageRepliesSize = [self infoSize:imageReplies];
		[int2str(imageReplies) drawInRect:CGRectMake(kPadding + kIconSpaceX + imageRepliesIcon.size.width, y+kIconSpaceY,
													 imageRepliesSize.width, imageRepliesSize.height)
								 withFont:infoFont];
//	}
	
	CGSize likesSize = [self infoSize:likes];
	x -= kIconSpaceX + likesIcon.size.width + likesSize.width;
	[likesIcon drawAtPoint:CGPointMake(x, y)];
	[int2str(likes) drawInRect:CGRectMake(x + kIconSpaceX + likesIcon.size.width, y+kIconSpaceY,
										  likesSize.width, likesSize.height)
					  withFont:infoFont];
	
	CGSize repliesSize = [self infoSize:replies];
	x -= kIconSpaceX + repliesIcon.size.width + repliesSize.width + 10.0;
	[repliesIcon drawAtPoint:CGPointMake(x, y)];
	[int2str(replies) drawInRect:CGRectMake(x + kIconSpaceX + repliesIcon.size.width, y+kIconSpaceY,
											repliesSize.width, repliesSize.height)
						withFont:infoFont];
	
	CGSize viewsSize = [self infoSize:views];
	x -= kIconSpaceX + viewsIcon.size.width + viewsSize.width + 10.0;
	[viewsIcon drawAtPoint:CGPointMake(x, y)];
	[int2str(views) drawInRect:CGRectMake(x + kIconSpaceX + viewsIcon.size.width, y+kIconSpaceY,
												 viewsSize.width, viewsSize.height)
							 withFont:infoFont];
}


- (void)setImageUrl:(NSString*)url
			   size:(CGSize)size {
	
	if (self.imageView) {
		[self.imageView removeFromSuperview];

		self.imageView.image = nil;
		self.imageView = nil;
	}
	
	self.imageView = [[[FLImageView alloc] initWithFrame:CGRectMake(kPadding, 4.0, size.width, size.height)] autorelease];
	self.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
	self.imageView.layer.shadowOpacity = 0.5f;
	self.imageView.layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
	self.imageView.layer.shadowRadius = 0.8f;
	self.imageView.layer.masksToBounds = NO;
	self.imageView.layer.shadowPath = [self renderPaperCurl:imageView.bounds.size];
	
	[self addSubview:self.imageView];
	
	UIImage * placeholder = [UIImage imageNamed:@"Default.png"];
	NSString *urlString = [NSString stringWithFormat:@"%@=s%.f", url, size.width * placeholder.scale];
	[self.imageView loadImageAtURLString:urlString placeholderImage:placeholder];
}

@end
