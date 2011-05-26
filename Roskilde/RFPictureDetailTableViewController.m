//
//  RFPictureDetailTableViewController.m
//  Roskilde
//
//  Created by Willi Wu on 25/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFPictureDetailTableViewController.h"
#import "RKCustomNavigationBar.h"
#import "ZoomingViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "JSONKit.h"


@implementation RFPictureDetailTableViewController

@synthesize entry = _entry;
@synthesize replies = _replies;
@synthesize zoomingView;


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
	self.entry = nil;
	self.replies = nil;
	[zoomingViewController release];
	zoomingViewController = nil;
	
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)awakeFromNib {
	[super awakeFromNib];
	
	//	self.entries = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// Custom navbar
	RKCustomNavigationBar *navBar = (RKCustomNavigationBar*)self.navigationController.navigationBar;
	[navBar setBackgroundWith:[UIImage imageNamed:@"sortbg.png"]];
	
	NSDictionary *author = [self.entry objectForKey:@"created_by"];
	NSString *username = [author objectForKey:@"username"];
	
	[self setWhiteTitle:[NSString stringWithFormat:@"%@'s Picture", username]];
	
	
	zoomingViewController = [[ZoomingViewController alloc] init];
	zoomingViewController.view = zoomingView;
	
//	CGRect zoomingViewFrame = zoomingViewController.view.frame;
//	CGRect ownBounds = self.view.bounds;
//	zoomingViewController.view.frame = CGRectMake(ownBounds.origin.x + 0.5 * (ownBounds.size.width - zoomingViewFrame.size.width),
//												  ownBounds.origin.y + 0.5 * (ownBounds.size.height - zoomingViewFrame.size.height),
//												  zoomingViewFrame.size.width,
//												  zoomingViewFrame.size.height);
	
	
	[self performSelector:@selector(refresh) withObject:nil afterDelay:0.0];
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	self.zoomingView = nil;
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
	
	[zoomingViewController dismissFullscreenView];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0)
	{
		return 300.0;
	}
	else {
		return 100.0;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.replies count] + 1;
}


- (void)configureCell:(UITableViewCell *)cell_
          atIndexPath:(NSIndexPath*)indexPath {
	
//	EntryTableViewCell * cell	= (EntryTableViewCell *)cell_;
	
//	NSDictionary *reply = [self.replies objectAtIndex:indexPath.section];
	
	cell_.textLabel.text = @"hi";
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *FirstCellIdentifier = @"FirstCell";
	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = nil;
	
	if (indexPath.row == 0)
	{
		cell = [tableView dequeueReusableCellWithIdentifier:FirstCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstCellIdentifier] autorelease];
			[cell addSubview:self.zoomingView];
		}
	}
	else
	{
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
//		[self configureCell:cell atIndexPath:indexPath];
	}
	
	// Configure the cell...
	
	return cell;
}

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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


- (void)refresh {
    [self performSelector:@selector(fetchReplies) withObject:nil afterDelay:0.0];
}

- (void)refreshDone {
	[self.tableView reloadData];
	[self stopLoading];
}

- (void)fetchReplies {
	NSString *urlString = [NSString stringWithFormat:@"%@/entries/%@/replies", kXdkAPIBaseUrl, [self.entry objectForKey:@"entry_id"]];
	NSURL *url = [NSURL URLWithString:urlString];
	__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDownloadCache:[ASIDownloadCache sharedCache]];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	[request setSecondsToCache:3600];
	
	[request setCompletionBlock:^{
		// Use when fetching text data
		NSString *responseString = [request responseString];
		
		// JSONKit parse
		id parsedData = [responseString objectFromJSONString];
		
		LOG_EXPR(parsedData);
		
		self.replies = nil;
		//		[self.entries addObjectsFromArray:parsedData];
		self.replies = [[[NSMutableArray alloc] initWithArray:parsedData] autorelease];
		
		[self refreshDone];
	}];
	[request setFailedBlock:^{
		NSError *error = [request error];
		NSLog(@"error: %@", error);
		
		[self refreshDone];
	}];
	[request startAsynchronous];
}


@end
