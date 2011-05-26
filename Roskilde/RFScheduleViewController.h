//
//  RFScheduleViewController.h
//  Roskilde
//
//  Created by Willi Wu on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "RFDateScrollerViewController.h"


@interface RFScheduleViewController : BaseViewController <RFDateScrollerViewControllerDelegate> {
    RFDateScrollerViewController * dateScroller;
	
	UIButton *orangeButton;
	UIButton *arenaButton;
	UIButton *cosmopolButton;
	UIButton *odeonButton;
	UIButton *pavilionButton;
	UIScrollView *timelineScrollView;
	
	NSUInteger currentPageNumber;
}

@property (nonatomic, retain) RFDateScrollerViewController *dateScroller;

@property (nonatomic, retain) IBOutlet UIScrollView *timelineScrollView;
@property (nonatomic, retain) IBOutlet UIButton *orangeButton;
@property (nonatomic, retain) IBOutlet UIButton *arenaButton;
@property (nonatomic, retain) IBOutlet UIButton *cosmopolButton;
@property (nonatomic, retain) IBOutlet UIButton *odeonButton;
@property (nonatomic, retain) IBOutlet UIButton *pavilionButton;

@end
