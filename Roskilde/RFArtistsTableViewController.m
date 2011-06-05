//
//  RFArtistsTableViewController.m
//  Roskilde
//
//  Created by Willi Wu on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFArtistsTableViewController.h"
#import "RFConcertDetailViewController.h"
#import "RFModelController.h"
#import "NSDate+Helper.h"



@interface RFArtistsTableViewController ()
- (void)sortByArtist;
- (void)sortByDate;
- (void)sortByGenre;
- (void)sortByStarred;
@end


@implementation RFArtistsTableViewController

@synthesize filtersView;
@synthesize filters;
@synthesize currentfetchedResultsController;
@synthesize artistsfetchedResultsController;
@synthesize datefetchedResultsController;
@synthesize genrefetchedResultsController;
@synthesize starredfetchedResultsController;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	self.currentfetchedResultsController = nil;
	self.artistsfetchedResultsController = nil;
	self.datefetchedResultsController = nil;
	self.genrefetchedResultsController = nil;
	self.starredfetchedResultsController = nil;
	[filtersView release];
	
    self.filters = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.title = NSLocalizedString(@"Artists", @"");

	// Uncomment the following line to preserve selection between presentations.
	//	self.clearsSelectionOnViewWillAppear = NO;

	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	CGRect frame = self.tableView.bounds;
	frame.origin.y = -frame.size.height;
	UIView* grayView = [[UIView alloc] initWithFrame:frame];
	grayView.backgroundColor = [UIColor colorWithRed:0.169 green:0.163 blue:0.163 alpha:1.000];
	[self.tableView addSubview:grayView];
	[grayView release];
	
	
	sortBy = SortByArtist;
	
	// Filters
	self.filters = [[[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"Artists", @"Date", @"Genre", @"Starred", nil]] autorelease];
	filters.selectedSegmentChangedHandler = ^(id sender) {
		SVSegmentedControl *f = (SVSegmentedControl *)sender;
		NSLog(@"segmentedControl %i did select index %i (captured via block)", f.tag, f.selectedIndex);
		
		if (f.selectedIndex == 0)
		{
			[self sortByArtist];
		}
		else if (f.selectedIndex == 1)
		{
			[self sortByDate];
		}
		else if (f.selectedIndex == 2)
		{
			[self sortByGenre];
		}
		else
		{
			[self sortByStarred];
		}
	};
	
	filters.crossFadeLabelsOnDrag = YES;
	filters.font = [UIFont boldSystemFontOfSize:14];
	filters.segmentPadding = 5;
	filters.height = 30;
	
	filters.thumb.tintColor = [UIColor colorWithRed:0.572 green:0.552 blue:0.529 alpha:1.000];
	
	[self.view addSubview:filters];
	
	filters.center = CGPointMake(160, 22);

	
	
	NSError *error = nil;
	self.currentfetchedResultsController = self.artistsfetchedResultsController;
	[[self currentfetchedResultsController] performFetch:&error];
}

- (void)viewDidUnload
{
	[self setFiltersView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	self.filters = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.

	if (self.currentfetchedResultsController == self.datefetchedResultsController
        || self.currentfetchedResultsController == self.starredfetchedResultsController) {
		return 1;
	}

	return [[self.currentfetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	if (self.currentfetchedResultsController == self.datefetchedResultsController
        || self.currentfetchedResultsController == self.starredfetchedResultsController) {
		return [[self.currentfetchedResultsController fetchedObjects] count];
	}
	
	id <NSFetchedResultsSectionInfo> sectionInfo = nil;
	NSArray * sections = [self.currentfetchedResultsController sections];
	if ([sections count] > 0) {
		sectionInfo = [sections objectAtIndex:section];
		return [sectionInfo numberOfObjects];
	}
	else {
		return 0;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIImageView * imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator.png"]];
	UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 1.0f, 200.f, 20.0f)];
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.currentfetchedResultsController sections] objectAtIndex:section];
	label.backgroundColor = [UIColor clearColor];
	label.text = [sectionInfo name];
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:18];
	[imageview addSubview:label];
    [label release];
	return [imageview autorelease];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.currentfetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.currentfetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}


- (void)configureCell:(UITableViewCell *)cell 
          atIndexPath:(NSIndexPath*)indexPath
{
    RFMusic *m = [[self.currentfetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
    
    LOG_EXPR(m.artist);
    LOG_EXPR(sortBy);
    
	RFMusic *music = [self.currentfetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = music.artist;
    
    if (music.beginDate) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@, %@", [music.beginDate formattedDateStringForDisplay], [music.beginDate formattedTimeStringForDisplay], music.scene];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	
	[self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//	cell.textLabel.textColor = [UIColor colorWithWhite:0.90 alpha:1.000];
//	
//	if (indexPath.row % 2)
//	{
//        cell.backgroundColor = [UIColor colorWithRed:0.166 green:0.163 blue:0.163 alpha:1.000];
//	}
//	else {
//		cell.backgroundColor = [UIColor colorWithWhite:0.101 alpha:1.000];
//	}
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Navigation logic may go here. Create and push another view controller.
	RFConcertDetailViewController *detailViewController = [[RFConcertDetailViewController alloc] initWithNibName:@"RFConcertDetailViewController" bundle:nil];
	// ...
	// Pass the selected object to the new view controller.
	detailViewController.concert = [self.currentfetchedResultsController objectAtIndexPath:indexPath];
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController*)artistsfetchedResultsController 
{
	if (artistsfetchedResultsController) return artistsfetchedResultsController;
	
	NSManagedObjectContext *managedObjectContext = [[[RFModelController defaultModelController] coreDataManager] managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Music" 
											  inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	[fetchRequest setFetchBatchSize:20];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"artist"
																   ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *frc = nil;
	frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
											  managedObjectContext:managedObjectContext
												sectionNameKeyPath:@"artistInitial"
														 cacheName:nil];
	[frc setDelegate:self];
	self.artistsfetchedResultsController = frc;
	[frc release], frc = nil;
	
	[fetchRequest release], fetchRequest = nil;
	[sortDescriptor release], sortDescriptor = nil;
	[sortDescriptors release], sortDescriptors = nil;
	
	return artistsfetchedResultsController;
}

- (NSFetchedResultsController*)datefetchedResultsController 
{
	if (datefetchedResultsController) return datefetchedResultsController;
	
	NSManagedObjectContext *managedObjectContext = [[[RFModelController defaultModelController] coreDataManager] managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Music" 
											  inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	[fetchRequest setFetchBatchSize:20];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"beginDate"
																   ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *frc = nil;
	frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
											  managedObjectContext:managedObjectContext
												sectionNameKeyPath:@"beginDateString"
														 cacheName:nil];
	[frc setDelegate:self];
	self.datefetchedResultsController = frc;
	[frc release], frc = nil;
	
	[fetchRequest release], fetchRequest = nil;
	[sortDescriptor release], sortDescriptor = nil;
	[sortDescriptors release], sortDescriptors = nil;
	
	return datefetchedResultsController;
}


- (NSFetchedResultsController*)genrefetchedResultsController 
{
	if (genrefetchedResultsController) return genrefetchedResultsController;
	
	NSManagedObjectContext *managedObjectContext = [[[RFModelController defaultModelController] coreDataManager] managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Music" 
											  inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	[fetchRequest setFetchBatchSize:20];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"genre"
																   ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"artist"
																   ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, sortDescriptor2, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *frc = nil;
	frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
											  managedObjectContext:managedObjectContext
												sectionNameKeyPath:@"genre"
														 cacheName:nil];
	[frc setDelegate:self];
	self.genrefetchedResultsController = frc;
	[frc release], frc = nil;
	
	[fetchRequest release], fetchRequest = nil;
	[sortDescriptor release], sortDescriptor = nil;
    [sortDescriptor2 release], sortDescriptor2 = nil;
	[sortDescriptors release], sortDescriptors = nil;
	
	return genrefetchedResultsController;
}


- (NSFetchedResultsController*)starredfetchedResultsController 
{
	if (starredfetchedResultsController) return starredfetchedResultsController;
	
	NSManagedObjectContext *managedObjectContext = [[[RFModelController defaultModelController] coreDataManager] managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Music" 
											  inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	[fetchRequest setFetchBatchSize:20];
	
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorite == %d", YES];
//	[fetchRequest setPredicate:predicate];
    
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"isFavorite"
																   ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *frc = nil;
	frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
											  managedObjectContext:managedObjectContext
												sectionNameKeyPath:nil //@"isFavorite"
														 cacheName:nil];
	[frc setDelegate:self];
	self.starredfetchedResultsController = frc;
	[frc release], frc = nil;
	
	[fetchRequest release], fetchRequest = nil;
	[sortDescriptor release], sortDescriptor = nil;
	[sortDescriptors release], sortDescriptors = nil;
	
	return starredfetchedResultsController;
}


- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller 
{
	[[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController*)controller 
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo 
           atIndex:(NSUInteger)sectionIndex 
     forChangeType:(NSFetchedResultsChangeType)type 
{
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[[self tableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] 
							withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
							withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controller:(NSFetchedResultsController*)controller 
   didChangeObject:(id)anObject 
       atIndexPath:(NSIndexPath*)indexPath 
     forChangeType:(NSFetchedResultsChangeType)type 
      newIndexPath:(NSIndexPath*)newIndexPath 
{
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
									withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
									withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate:
//			[self configureCell:[[self tableView] cellForRowAtIndexPath:indexPath]
//					atIndexPath:indexPath];
			break;
		case NSFetchedResultsChangeMove:
			[[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
									withRowAnimation:UITableViewRowAnimationFade];
			[[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
									withRowAnimation:UITableViewRowAnimationFade];
			break;
	}  
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller 
{
	[[self tableView] endUpdates];
	
	[self.tableView bringSubviewToFront:self.filters];
} 



- (void)sortByArtist {
	sortBy = SortByArtist;
	
	self.currentfetchedResultsController = self.artistsfetchedResultsController;
    
    [NSFetchedResultsController deleteCacheWithName:nil];
	
	NSError *error;
	if (![[self currentfetchedResultsController] performFetch:&error]) {
        // Handle you error here
	}
	
	[self.tableView reloadData];
}

- (void)sortByDate {
	sortBy = SortByDate;
	
	self.currentfetchedResultsController = self.datefetchedResultsController;
	
    [NSFetchedResultsController deleteCacheWithName:nil];
    
	NSError *error;
	if (![[self currentfetchedResultsController] performFetch:&error]) {
        // Handle you error here
	}
	
	[self.tableView reloadData];
}

- (void)sortByGenre {
	sortBy = SortByGenre;
	
	self.currentfetchedResultsController = self.genrefetchedResultsController;
	
    [NSFetchedResultsController deleteCacheWithName:nil];
    
	NSError *error;
	if (![[self currentfetchedResultsController] performFetch:&error]) {
        // Handle you error here
	}
	
	[self.tableView reloadData];
}

- (void)sortByStarred {
	sortBy = SortByStarred;
	
	self.currentfetchedResultsController = self.starredfetchedResultsController;
	
    [NSFetchedResultsController deleteCacheWithName:nil];
    
	NSError *error;
	if (![[self currentfetchedResultsController] performFetch:&error]) {
        // Handle you error here
	}
	
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Content Filtering

//- (void)filterContent {
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@ AND userId != %d", query, profile.userIdValue];
//    [NSFetchedResultsController deleteCacheWithName:nil];
//    [self.currentfetchedResultsController.fetchRequest setPredicate:predicate];
//    
//	NSError *error = nil;
//	if (![self.currentfetchedResultsController performFetch:&error]) {
//		// Handle error
//		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//		exit(-1);  // Fail
//	}
//	
//	[self.tableView reloadData];
//}


@end
