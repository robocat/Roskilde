//
//  RFPassThroughView.m
//  Roskilde
//
//  Created by Willi Wu on 18/06/10.
//  Copyright 2010 Robocat. All rights reserved.
//

#import "RFPassThroughView.h"


@implementation RFPassThroughView


- (void)dealloc {
	[_scrollView release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIView methods

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	if ([self pointInside:point withEvent:event]) {
		return _scrollView;
	}
	return nil;
}

@end
