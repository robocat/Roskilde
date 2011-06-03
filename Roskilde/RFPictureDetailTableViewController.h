//
//  RFPictureDetailTableViewController.h
//  Roskilde
//
//  Created by Willi Wu on 25/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRefreshViewController.h"
#import "FLImageView.h"
#import "UIInputToolbar.h"



@protocol RFPictureDetailTableViewControllerDelegate
- (void)dismissTextInput;
@end

@interface RFPictureDetailTableViewController : BaseRefreshViewController <UIInputToolbarDelegate, RFPictureDetailTableViewControllerDelegate> {
    NSDictionary * _entry;
	NSArray * _replies;
	
	UIView *zoomingView;
	FLImageView *imageView;
	
	UIView *toolbar;
	UIInputToolbar *inputToolbar;
	UIImageView *toolbarImageView;
	
	UIButton *cameraButton;
	UIButton *inputButton;
	UIButton *likeButton;
	
@private
    BOOL keyboardIsVisible;

}

@property (nonatomic, retain) NSDictionary *entry;
@property (nonatomic, retain) NSArray *replies;
@property (nonatomic, retain) IBOutlet UIView *zoomingView;
@property (nonatomic, retain) IBOutlet FLImageView *imageView;
@property (nonatomic, retain) IBOutlet UIView *toolbar;
@property (nonatomic, retain) UIInputToolbar *inputToolbar;
@property (nonatomic, retain) IBOutlet UIImageView *toolbarImageView;

@property (nonatomic, retain) IBOutlet UIButton *cameraButton;
@property (nonatomic, retain) IBOutlet UIButton *inputButton;
@property (nonatomic, retain) IBOutlet UIButton *likeButton;


- (void)cameraButtonPressed:(id)sender;
- (void)replyButtonPressed:(id)sender;
- (void)likeButtonPressed:(id)sender;

@end
