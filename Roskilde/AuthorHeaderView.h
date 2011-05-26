//
//  AuthorHeaderView.h
//  XKamera
//
//  Created by Willi Wu on 24/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLImageView.h"

@interface AuthorHeaderView : UIView {
	id target;
	SEL action;
	
	FLImageView *imageView;
	UIButton *nameButton;
	
	NSString	*location;
	NSDate		*creationDate;
}

@property (assign) id target;
@property (assign) SEL action;
@property (nonatomic, retain) FLImageView *imageView;
@property (nonatomic, retain) UIButton *nameButton;

- (id) initWithEntry:(NSDictionary *)entry frame:(CGRect)frame;

//+ (AuthorHeaderView *)addTarget:(id)aTarget action:(SEL)selector;
//- (void)fire;

@end
