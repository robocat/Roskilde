//
//  RFTimelineViewController.h
//  Roskilde
//
//  Created by Willi Wu on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface RFTimelineViewController : UIViewController <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *fetchedResultsController;
	
	UIImageView * redline;
}

@property (nonatomic, assign) UINavigationController *navigationController;
@property (nonatomic, retain) NSDate *currentDate;
@property (nonatomic, retain) UIImageView *redline;

- (void)changeDate:(NSDate*)newDate;

@end
