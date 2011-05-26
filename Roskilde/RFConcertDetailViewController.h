//
//  RFConcertDetailViewController.h
//  Roskilde
//
//  Created by Willi Wu on 26/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface RFConcertDetailViewController : BaseViewController {
    
	UIButton *starButton;
	UIButton *websiteButton;
	UIButton *itunesButton;
	UILabel *artistLabel;
	UILabel *playtimeLabel;
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

- (IBAction)toggleInfoView:(id)sender;

@end
