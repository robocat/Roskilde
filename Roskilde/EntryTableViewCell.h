//
//  EntryTableViewCell.h
//  XKamera
//
//  Created by Willi Wu on 20/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RKTableViewCell.h"
#import "FLImageView.h"


@interface EntryTableViewCell : RKTableViewCell {
	
	NSInteger imageReplies;
	NSInteger views;
	NSInteger replies;
	NSInteger likes;
	
	FLImageView *avatarView;
	FLImageView *imageView;
	CGFloat		imageHeight;
	
@private
	UIImage *imageRepliesIcon;
	UIImage *viewsIcon;
	UIImage *repliesIcon;
	UIImage *likesIcon;
}

@property (nonatomic, assign) NSInteger imageReplies;
@property (nonatomic, assign) NSInteger views;
@property (nonatomic, assign) NSInteger replies;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, retain) FLImageView *imageView;


- (void)setImageUrl:(NSString*)url size:(CGSize)size;

@end
