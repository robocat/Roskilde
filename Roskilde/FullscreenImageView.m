//
//  FullscreenImageView.m
//  Roskilde
//
//  Created by Ulrik Damm on 6/1/11.
//  Copyright 2011 Gereen.dk. All rights reserved.
//

#import "FullscreenImageView.h"

@interface FullscreenImageView ()

@property (nonatomic, retain) UIImageView *fullscreenView;

@end


@implementation FullscreenImageView

@synthesize fullscreenView;

- (void)awakeFromNib {
	self.fullscreenView = nil;
}


- (void)fullscreen {
	CGPoint position =  CGPointMake(0, 0);
	
	UIView *superView = self;
	
	do {
		position.x += superView.frame.origin.x + superView.bounds.origin.x;
		position.y += superView.frame.origin.y + superView.bounds.origin.x;
	} while ((superView = superView.superview) != nil);
	
	self.fullscreenView = [[UIImageView alloc] initWithFrame:CGRectMake(position.x, position.y, self.bounds.size.width, self.bounds.size.height)];
	
	self.fullscreenView.image = self.image;
	self.fullscreenView.clipsToBounds = self.clipsToBounds;
	self.fullscreenView.contentMode = UIViewContentModeScaleAspectFit;
	self.fullscreenView.alpha = 0;
	
	[[[UIApplication sharedApplication] keyWindow] addSubview:self.fullscreenView];
	
	[UIView animateWithDuration:1 animations:^(void) {
		self.fullscreenView.frame = CGRectMake(0, 0, 320, 480);
		self.fullscreenView.alpha = 1;
	}];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	[self fullscreen];
	
	return nil;
}

@end
