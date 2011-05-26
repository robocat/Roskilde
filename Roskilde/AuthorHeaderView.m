//
//  AuthorHeaderView.m
//  XKamera
//
//  Created by Willi Wu on 24/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthorHeaderView.h"
#import "UIButton+CustomButtons.h"
#import "NSDateHelper.h"


@implementation AuthorHeaderView

@synthesize target, action, imageView, nameButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		
    }
    return self;
}

- (id) initWithEntry:(NSDictionary *)anEntry frame:(CGRect)frame
{
	self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor colorWithRed:0.921 green:0.922 blue:0.921 alpha:0.3];
		
		self.imageView = [[FLImageView alloc] initWithFrame:CGRectMake(20.0, 4.0, 20.0, 20.0)];
		[self addSubview:imageView];
		
		NSDictionary *author = [anEntry objectForKey:@"created_by"];
		NSString *name = [author objectForKey:@"fullname"];
		if (name)
		{
			self.nameButton = [[UIButton buttonWithAuthorName:name] retain];
			[self addSubview:nameButton];
		}
		
		location = [[anEntry objectForKey:@"location"] retain];
		
		creationDate = [[NSDate localDateFromUTCFormattedDate:[NSDate dateWithDateTimeString:[anEntry objectForKey:@"created_at"]]] retain];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	
	UIFont *timeFont		= [UIFont boldSystemFontOfSize:12];
	
	[[UIColor colorWithRed:0.651 green:0.651 blue:0.651 alpha:1.000] set];
	
	[location drawInRect:CGRectMake(10.0, 14.0, 200.0, 20.0)
				withFont:timeFont];
	
	NSString *dateString	= [creationDate formattedExactRelativeShortDate];
	
	CGSize size = [dateString sizeWithFont:timeFont
						  constrainedToSize:CGSizeMake(FLT_MAX, 20.0)
							  lineBreakMode:UILineBreakModeTailTruncation];
	
	CGFloat y = 310.0;
	
	UIImage *clock = [UIImage imageNamed:@"time_icon.png"];
	[clock drawAtPoint:CGPointMake(y - clock.size.width - 4.0 - size.width, 7.0)];
	
	[dateString drawInRect:CGRectMake(y - size.width, 7.0, size.width, size.height)
				  withFont:timeFont];
}

- (void)dealloc
{
	[imageView release];
	self.imageView = nil;
	
	[nameButton release];
	self.nameButton = nil;
	
	[location release];
	
	[creationDate release];
	
    [super dealloc];
}

@end
