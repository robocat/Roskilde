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
}

@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) NSDate *currentDate;

- (void)changeDate:(NSDate*)newDate;

@end
