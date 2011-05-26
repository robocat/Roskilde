//
//  RFPictureDetailTableViewController.h
//  Roskilde
//
//  Created by Willi Wu on 25/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRefreshTableViewController.h"


@class ZoomingViewController;

@interface RFPictureDetailTableViewController : BaseRefreshTableViewController {
    NSDictionary * _entry;
	NSArray * _replies;
	
	ZoomingViewController *zoomingViewController;
	UIView *zoomingView;
}

@property (nonatomic, retain) NSDictionary *entry;
@property (nonatomic, retain) NSArray *replies;
@property (nonatomic, retain) IBOutlet UIView *zoomingView;

@end
