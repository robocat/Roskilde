//
//  RFArtistsTableViewController.h
//  Roskilde
//
//  Created by Willi Wu on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import <CoreData/CoreData.h>


@interface RFArtistsTableViewController : BaseTableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *	fetchedResultsController;
	UIView *filtersView;
}

@property (nonatomic, retain) IBOutlet UIView *filtersView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
