//
//  RKTableViewCell.m
//  XKamera
//
//  Created by Willi Wu on 20/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RKTableViewCell.h"


@interface RKTableViewCellView : UIView
@end

@implementation RKTableViewCellView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	[(RKTableViewCell *)[self superview] drawContentView:rect];
}

@end


@implementation RKTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.contentView.hidden = YES;
		self.backgroundView.hidden = YES;
		self.textLabel.hidden = YES;
		self.detailTextLabel.hidden = YES;
		self.imageView.hidden = YES;
		
		_cellView = [[RKTableViewCellView alloc] initWithFrame:CGRectZero];
		[self addSubview:_cellView];
		[self bringSubviewToFront:_cellView];
		[_cellView release];
    }
    return self;
}


- (void)setNeedsDisplay {
	[super setNeedsDisplay];
	[_cellView setNeedsDisplay];
}


- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	CGRect bounds = [self bounds];
	bounds.size.height -= 1;
	_cellView.frame = bounds;
	[self setNeedsDisplay];
}


- (void)drawContentView:(CGRect)rect {
	// Subclasses should implement this
}

@end