//
//  UIButton+CustomButtons.m
//  XKamera
//
//  Created by Willi Wu on 24/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIButton+CustomButtons.h"


@implementation UIButton (CustomButtons)

+ (UIButton *) buttonWithAuthorName:(NSString *)name {
	UIFont * font			= [UIFont boldSystemFontOfSize:12.0];
	CGSize size				= [name sizeWithFont:font
					  constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)
						  lineBreakMode:UILineBreakModeTailTruncation];
	
	UIButton *button					= [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame						= CGRectMake(10.0, 0.0, size.width + 4.0, size.height + 2.0);
	button.titleLabel.font				= font;
	button.contentVerticalAlignment		= UIControlContentVerticalAlignmentCenter;
	button.titleEdgeInsets				= UIEdgeInsetsMake(0.0, -3.0, 0.0, 0.0);
	
	[button setTitle:name forState:UIControlStateNormal];
	[button setTitleColor:[UIColor colorWithRed:0.215 green:0.257 blue:0.497 alpha:1.000] forState:UIControlStateNormal];
	[button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
	return button;
}

@end
