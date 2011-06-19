//
//  FullscreenViewController.m
//  Roskilde
//
//  Created by Ulrik Damm on 6/1/11.
//  Copyright 2011 Gereen.dk. All rights reserved.
//

#import "FullscreenViewController.h"

@interface FullscreenViewController ()

- (void)fullscreen:(id)sender;

@property (nonatomic, retain) UIView *fullscreenView;
@property (nonatomic, assign) BOOL isFullscreen;
@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, retain) UIView *bView;

@end


@implementation FullscreenViewController

@synthesize fullscreenView;
@synthesize isFullscreen;
@synthesize oldFrame;
@synthesize bView;
@synthesize delegate;

- (id)init {
	if ((self = [super init])) {
		self.isFullscreen = NO;
		
//		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeFullscreen) 
//													 name:kAppEnterBackground object:nil];
	}
	
	return self;
}


- (id)initAsFullscreenWithView:(UIView*)v oldFrame:(CGRect)f backView:(UIView*)backView {
	if ((self = [super init])) {
		self.view = v;
		self.isFullscreen = YES;
		self.oldFrame = f;
		self.bView = backView;
	}
	
	return self;
}


- (void)fullscreen:(id)sender {
	[self fullscreen];
}


//- (void)removeFullscreen {
//	[self.fullscreenView removeFromSuperview];
//}


- (void)fullscreen {
	if (self.isFullscreen) {
		if ([[UIApplication sharedApplication] isStatusBarHidden]) {
			[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
		}
		
		[UIView animateWithDuration:.3 animations:^(void) {
			if ([self.view isKindOfClass:[UIImageView class]]) {
				UIImage *image = [(UIImageView*)self.view image];
				
				if (image.size.width > image.size.height) {
					[self.view setTransform:CGAffineTransformMakeRotation(0)];
				}
			}
			
			self.view.alpha = 0;
			self.view.frame = self.oldFrame;
		} completion:^(BOOL finished) {
			self.bView.hidden = NO;
			[self.view removeFromSuperview];
			[self release];
		}];
	} else if (self.fullscreenView == nil) {
		CGPoint position =  CGPointMake(0, 0);
		
		UIView *superView = self.view;
		
		do {
			position.x += superView.frame.origin.x + superView.bounds.origin.x;
			position.y += superView.frame.origin.y + superView.bounds.origin.x;
		} while ((superView = superView.superview) != nil);
		
		self.fullscreenView = [[[self.view class] alloc] initWithFrame:CGRectMake(position.x, position.y, self.view.bounds.size.width, self.view.bounds.size.height)];
		CGRect old = self.fullscreenView.frame;
		
		if ([self.view isKindOfClass:[UIImageView class]]) {
			[(UIImageView*)(self.fullscreenView) setImage:[((UIImageView*)self.view) image]];
		}
		
		self.fullscreenView.clipsToBounds = self.view.clipsToBounds;
		self.fullscreenView.contentMode = self.view.contentMode;
		self.fullscreenView.backgroundColor = [UIColor blackColor];
		self.fullscreenView.userInteractionEnabled = YES;
		self.fullscreenView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.fullscreenView.alpha = 0;
		
		if (![[UIApplication sharedApplication] isStatusBarHidden]) {
			[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
		}
		[[[UIApplication sharedApplication] keyWindow] addSubview:self.fullscreenView];
		
//		self.view.hidden = YES;
		
		[UIView animateWithDuration:.3 animations:^(void) {
			if ([self.view isKindOfClass:[UIImageView class]]) {
				UIImage *image = [(UIImageView*)self.view image];
				
				if (image.size.width > image.size.height) {
					[self.fullscreenView setTransform:CGAffineTransformMakeRotation(M_PI_2)];
				}
			}
			
			self.fullscreenView.alpha = 1;
			self.fullscreenView.frame = CGRectMake(0, 0, 320, 480);
		} completion:^(BOOL finished) {
			self.fullscreenView = nil;
		}];
		
		[[[self class] alloc] initAsFullscreenWithView:self.fullscreenView oldFrame:old backView:self.view];
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.delegate dismissTextInput];
	[self fullscreen];
}

@end
