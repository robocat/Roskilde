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


@implementation RFArtistsTableViewController

@synthesize fetchedResultsController;

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
	fetchedResultsController = nil;
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
	
	NSError *error = nil;
	[[self fetchedResultsController] performFetch:&error];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return [[fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = nil;
	NSArray * sections = [fetchedResultsController sections];
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
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	label.backgroundColor = [UIColor clearColor];
	label.text = [sectionInfo name];
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:18];
	[imageview addSubview:label];
    [label release];
	return [imageview autorelease];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}


- (void)configureCell:(UITableViewCell *)cell 
          atIndexPath:(NSIndexPath*)indexPath
{
	RFMusic *music = [fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = music.artist;
//	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@, %@", [music.beginDate formattedDateStringForDisplay], [music.beginDate formattedTimeStringForDisplay], music.venue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
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
	detailViewController.concert = [fetchedResultsController objectAtIndexPath:indexPath];
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController*)fetchedResultsController 
{
	if (fetchedResultsController) return fetchedResultsController;
	
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
	[self setFetchedResultsController:frc];
	[frc release], frc = nil;
	
	[fetchRequest release], fetchRequest = nil;
	[sortDescriptor release], sortDescriptor = nil;
	[sortDescriptors release], sortDescriptors = nil;
	
	return fetchedResultsController;
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
			[self configureCell:[[self tableView] cellForRowAtIndexPath:indexPath]
					atIndexPath:indexPath];
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
} 


@end
