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
	
	NSInteger	imageReplies;
	NSInteger	views;
	NSInteger	replies;
	NSInteger	likes;
	NSString	*author;
	NSString	*location;
	NSDate		*creationDate;
	
	
	FLImageView *avatarView;
	FLImageView *imageView;
	CGFloat		imageHeight;

	id target;
	SEL action;
	
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
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSDate *creationDate;
@property (nonatomic, retain) FLImageView *avatarView;
@property (nonatomic, retain) FLImageView *imageView;
@property (nonatomic, assign) CGFloat imageHeight;

@property (assign) id target;
@property (assign) SEL action;

- (void)setAvatarUrl:(NSString*)url size:(CGSize)size;
- (void)setImageUrl:(NSString*)url size:(CGSize)size;

@end
