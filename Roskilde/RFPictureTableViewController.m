//
//  RFPictureTableViewController.m
//  Roskilde
//
//  Created by Willi Wu on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFPictureTableViewController.h"
#import "EntryTableViewCell.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "JSONKit.h"
#import "RFPictureDetailTableViewController.h"
#import "AuthorHeaderView.h"


@implementation RFPictureTableViewController

@synthesize entries = _entries;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		
    }
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	//	self.entries = [[NSMutableArray alloc] init];
}

- (void)dealloc
{
	[_entries release];
	self.entries = nil;
	
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
	
	self.title = NSLocalizedString(@"Pictures", @"");
	
	[self performSelector:@selector(refresh) withObject:nil afterDelay:0.0];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	LOG_EXPR([self.entries count]);
	
    return [self.entries count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	//	UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	//	return cell.frame.size.height;
	
	NSDictionary *entry = [self.entries objectAtIndex:indexPath.section];
	float defaultWidth = 300.0;
	int width	= [[entry objectForKey:@"width"] intValue];
	int height	= [[entry objectForKey:@"height"] intValue];
	if (width == 0)
		width = 640;
	if (height == 0)
		height = 480;
	
	float newHeight = defaultWidth / ((float)width / (float)height);
	
	return newHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 20.0;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
	NSDictionary *entry = [self.entries objectAtIndex:section];
	AuthorHeaderView *authorView = nil;
	if (entry)
	{
		authorView = [[[AuthorHeaderView alloc] initWithEntry:entry frame:CGRectMake(0, 0, 320, 30)] autorelease];
	}
	
	return authorView;
}


- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
	label.backgroundColor = [UIColor clearColor];
	label.text = @"";
	
	return [label autorelease];
}


- (void)configureCell:(UITableViewCell *)cell_
          atIndexPath:(NSIndexPath*)indexPath {
	
	EntryTableViewCell * cell	= (EntryTableViewCell *)cell_;
	
	NSDictionary *entry = [self.entries objectAtIndex:indexPath.section];
	
	cell.imageReplies			= [[entry objectForKey:@"image_replies_count"] intValue];
	cell.views					= 3;
	cell.replies				= [[entry objectForKey:@"comment_replies_count"] intValue];
	cell.likes					= 4;
	
	float defaultWidth = 280.0;
	int width	= [[entry objectForKey:@"width"] intValue];
	int height	= [[entry objectForKey:@"height"] intValue];
	if (width == 0)
		width = 640;
	if (height == 0)
		height = 480;
	float newHeight = defaultWidth / ((float)width / (float)height);
	
	[cell setImageUrl:[entry objectForKey:@"image_url"] size:CGSizeMake(defaultWidth, newHeight)];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell * cell = nil;
	cell = (EntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[EntryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	[self configureCell:cell atIndexPath:indexPath];
	
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
	RFPictureDetailTableViewController *detailViewController = [[RFPictureDetailTableViewController alloc] initWithNibName:@"RFPictureDetailTableViewController" bundle:nil];
	detailViewController.entry = [self.entries objectAtIndex:indexPath.section];
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}


- (void)refresh {
    [self performSelector:@selector(fetchLiveFeed) withObject:nil afterDelay:0.0];
}

- (void)refreshDone {
	[self.tableView reloadData];
	[self stopLoading];
}

- (void)fetchLiveFeed {
	NSString *urlString = [NSString stringWithFormat:@"%@/entries/", kXdkAPIBaseUrl];
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
		
		self.entries = nil;
		//		[self.entries addObjectsFromArray:parsedData];
		self.entries = [[[NSMutableArray alloc] initWithArray:parsedData] autorelease];
		
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
