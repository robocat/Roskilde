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
#import "SVSegmentedControl.h"


typedef enum {
	SortByArtist = 0,
	SortByDate,
	SortByGenre,
	SortByStarred,
} SortBy;


@interface RFArtistsTableViewController : BaseTableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *	currentfetchedResultsController;
	NSFetchedResultsController *	artistsfetchedResultsController;
	NSFetchedResultsController *	datefetchedResultsController;
	NSFetchedResultsController *	genrefetchedResultsController;
	NSFetchedResultsController *	starredfetchedResultsController;
	
	
	
	UIView *filtersView;
	SVSegmentedControl *filters;
	
	SortBy sortBy;
}

@property (nonatomic, retain) IBOutlet UIView *filtersView;
@property (nonatomic, retain) SVSegmentedControl *filters;
@property (nonatomic, retain) NSFetchedResultsController *currentfetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *artistsfetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *datefetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *genrefetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *starredfetchedResultsController;


@end
