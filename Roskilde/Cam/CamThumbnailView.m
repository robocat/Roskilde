//
//  CamThumbnailView.m
//  Cam
//
//  Created by Ulrik Damm on 28/4/11.
//  Copyright 2011 ITU. All rights reserved.
//

#import "CamThumbnailView.h"
#import <QuartzCore/QuartzCore.h>


@interface CamThumbnailView ()

@property (nonatomic, retain) NSMutableArray *thumbnails;

@end


@implementation CamThumbnailView

@synthesize thumbnails;
@synthesize thumbnailDelegate;

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		self.thumbnails = [NSMutableArray array];
	}
	
	return self;
}


- (NSArray*)allThumbnails {
	NSMutableArray *array = [NSMutableArray array];
	
	int i;
	for (i = [self.thumbnails count]-1; i >= 0; i--) {
		[array addObject:[[self.thumbnails objectAtIndex:i] imageForState:UIControlStateNormal]];
	}
	
	return array;
}


- (void)buttonAction:(UIButton*)sender {
	[thumbnailDelegate ThumbnailViewThumbnailPressed:[self.thumbnails count]-1-[self.thumbnails indexOfObject:sender]];
}


- (void)removeThumbnailAtIndex:(int)index {
	/*NSLog(@"thumbnails 1: %@", thumbnails);
	
	[[self.thumbnails objectAtIndex:index] removeFromSuperview];
	[self.thumbnails removeObjectAtIndex:index];
	
	NSLog(@"thumbnails 2: %@", thumbnails);
	
	int i;
	for (i = index-1; i >= 0; i--) {
		NSLog(@"%i", i);
		
		[self.thumbnails insertObject:[self.thumbnails objectAtIndex:i] atIndex:i+1];
		
		if (i == 0) {
			[self.thumbnails removeObjectAtIndex:0];
		}
		
		UIImageView *thumb = [thumbnails objectAtIndex:i+1];
		thumb.frame = CGRectMake((i-1)*60+15, 5, 50, 50);
	}
	
	NSLog(@"thumbnails 2: %@", thumbnails);*/
}


- (void)addThumbnail:(UIImage*)thumbnail {
	UIButton *imageView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	imageView.frame = CGRectMake(-60, 5, 50, 50);
	[imageView setImage:thumbnail forState:UIControlStateNormal];
	[imageView setImage:thumbnail forState:UIControlStateHighlighted];
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	[imageView addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
	imageView.layer.shadowColor = [UIColor blackColor].CGColor;
	imageView.layer.shadowOffset = CGSizeMake(0, 0);
	imageView.layer.shadowRadius = 2.5;
	imageView.layer.shadowOpacity = 1;
	
	CGMutablePathRef shadowPath = CGPathCreateMutable();
	CGPathAddRect(shadowPath, NULL, imageView.bounds);
	imageView.layer.shadowPath = shadowPath;
	CGPathRelease(shadowPath);
	
	[self addSubview:imageView];
	[thumbnails addObject:imageView];
	
	if ([thumbnails count] > 5) {
		UIView *thumb = [thumbnails objectAtIndex:0];
		[UIView animateWithDuration:0.3 delay:0.6 options:0 animations:^(void) {
			CGRect f = [thumb frame];
			
			[thumb setFrame:CGRectMake(f.origin.x, f.origin.y+100, f.size.width, f.size.height)];
			[thumb setTransform:CGAffineTransformMakeRotation(M_PI_2)];
		} completion:^(BOOL finished) {
			[thumb removeFromSuperview];
		}];
		
		[thumbnails removeObjectAtIndex:0];
	}
	
	int i;
	for (i = 0; i < ([thumbnails count] >= 5? 5: [thumbnails count]); i++) {
		UIImageView *thumb = [thumbnails objectAtIndex:[thumbnails count]-1-i];
		[UIView animateWithDuration:0.3 delay:i/20.0+(i == 0? 0.48: 0.5) options:(i == 0? 0: UIViewAnimationOptionCurveEaseOut) | UIViewAnimationOptionBeginFromCurrentState animations:^{
			thumb.frame = CGRectMake(i*60+15, 5, 50, 50);
		} completion:nil];
	}
}

@end
