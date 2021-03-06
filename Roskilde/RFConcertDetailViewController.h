//
//  RFConcertDetailViewController.h
//  Roskilde
//
//  Created by Willi Wu on 26/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class RFMusic2011;

@interface RFConcertDetailViewController : BaseViewController {
    
	RFMusic2011 *_concert;
	
	UIButton *starButton;
	UIButton *websiteButton;
	UIButton *itunesButton;
	UILabel *artistLabel;
	UILabel *playtimeLabel;
	UIImageView *genreImageView;
	UIImageView *sceneImageView;
	UITextView *descriptionTextView;
	UIImageView *artistImage;
	UIButton *titleButton;
	UIView *infoView;
}

@property (nonatomic, retain) RFMusic2011 *concert;

@property (nonatomic, retain) IBOutlet UIView *infoView;
@property (nonatomic, retain) IBOutlet UIButton *titleButton;
@property (nonatomic, retain) IBOutlet UIButton *starButton;
@property (nonatomic, retain) IBOutlet UIButton *websiteButton;
@property (nonatomic, retain) IBOutlet UIButton *itunesButton;
@property (nonatomic, retain) IBOutlet UILabel *artistLabel;
@property (nonatomic, retain) IBOutlet UILabel *playtimeLabel;
@property (nonatomic, retain) IBOutlet UIImageView *genreImageView;
@property (nonatomic, retain) IBOutlet UIImageView *sceneImageView;
@property (nonatomic, retain) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, retain) IBOutlet UIImageView *artistImage;

- (IBAction)hideInfoView:(id)sender;
- (IBAction)toggleInfoView:(id)sender;
- (IBAction)favorite:(id)sender;
- (IBAction)websitePressed:(id)sender;
- (IBAction)itunesPressed:(id)sender;


@end
