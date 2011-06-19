//
//  RFRobocatViewController.h
//  Roskilde
//
//  Created by Willi Wu on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface RFRobocatViewController : BaseViewController {
    
	UIButton *starButton;
	UIButton *websiteButton;
	UIButton *itunesButton;
	UILabel *artistLabel;
	UILabel *playtimeLabel;
	UITextView *descriptionTextView;
	UILabel *msgLabel;
	UIButton *titleButton;
	UIView *infoView;
}

@property (nonatomic, retain) IBOutlet UIView *infoView;
@property (nonatomic, retain) IBOutlet UIButton *titleButton;
@property (nonatomic, retain) IBOutlet UIButton *starButton;
@property (nonatomic, retain) IBOutlet UIButton *websiteButton;
@property (nonatomic, retain) IBOutlet UIButton *itunesButton;
@property (nonatomic, retain) IBOutlet UILabel *artistLabel;
@property (nonatomic, retain) IBOutlet UILabel *playtimeLabel;
@property (nonatomic, retain) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, retain) IBOutlet UILabel *msgLabel;

- (IBAction)hideInfoView:(id)sender;
- (IBAction)toggleInfoView:(id)sender;

- (IBAction)starButtonPressed:(id)sender;
- (IBAction)websitePressed:(id)sender;
- (IBAction)itunesButtonPressed:(id)sender;

@end
