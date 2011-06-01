//
//  RFPictureTableViewController.m
//  Roskilde
//
//  Created by Willi Wu on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFPictureTableViewController.h"
#import "RKCustomNavigationBar.h"
#import "EntryTableViewCell.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "JSONKit.h"
#import "RFPictureDetailTableViewController.h"
#import "NSDateHelper.h"
#import "RFCreateProfileViewController.h"
#import "NSDictionaryHelper.h"


#define kImageDisplayWidth		280.0
#define kImageDisplayHeight		210.0
#define kImageDownloadWidth		320.0
#define kImageDownloadHeight	240.0


@implementation RFPictureTableViewController

@synthesize entries = _entries;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		
    }
    return self;
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

- (void)awakeFromNib {
	[super awakeFromNib];
	
	//	self.entries = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Pictures", @"");
	
	
	// Create cancel button and assign it
	UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStyleBordered target:self action:@selector(createProfile)];
	self.navigationItem.leftBarButtonItem = createButton;
	[createButton release];

	
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
	
	// Custom navbar
	RKCustomNavigationBar *navBar = (RKCustomNavigationBar*)self.navigationController.navigationBar;
	[navBar setBackgroundWith:[UIImage imageNamed:@"navbar.png"]];

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
    return [self.entries count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat) entryHeightWithWidth:(CGFloat)width height:(CGFloat)height {
	float defaultWidth = kImageDownloadWidth;
	if (width == 0)
		width = 640;
	if (height == 0)
		height = 480;
	
	return (defaultWidth / ((float)width / (float)height));
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return kImageDisplayHeight + 100.0;
}

- (void)configureCell:(UITableViewCell *)cell_
          atIndexPath:(NSIndexPath*)indexPath {
	
	EntryTableViewCell * cell	= (EntryTableViewCell *)cell_;
	
	NSDictionary *entry = [self.entries objectAtIndex:indexPath.section];
	
	NSDictionary *author		= [entry objectForKey:@"created_by"];
	cell.author					= [author objectOrEmptyStringForKey:@"fullname"];
	cell.location				= [entry objectOrEmptyStringForKey:@"location"];
	cell.creationDate			= [NSDate localDateFromUTCFormattedDate:[NSDate dateWithDateTimeString:[entry objectForKey:@"created_at"]]];
	cell.imageReplies			= [[entry objectForKey:@"image_replies_count"] intValue];
	cell.views					= [[entry objectForKey:@"views_count"] intValue];;
	cell.replies				= [[entry objectForKey:@"comment_replies_count"] intValue];
	cell.likes					= [[entry objectForKey:@"likers"] count];
	
	int width	= [[entry objectForKey:@"width"] intValue];
	int height	= [[entry objectForKey:@"height"] intValue];
	CGFloat dlHeight = [self entryHeightWithWidth:width height:height];
	
	cell.imageHeight = kImageDisplayHeight;
	
	[cell setAvatarUrl:[author objectForKey:@"avatar_url"] size:CGSizeMake(22.0, 22.0)];
	[cell setImageUrl:[entry objectForKey:@"image_url"]
				 size:CGSizeMake(kImageDisplayWidth, kImageDisplayHeight)
			   dlsize:CGSizeMake(kImageDownloadWidth, dlHeight)];
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
	detailViewController.hidesBottomBarWhenPushed = YES;
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
		
		LOG_EXPR(parsedData);
		
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


- (void)dismissModal {
	[self.modalViewController dismissModalViewControllerAnimated:YES];
}

- (void)createProfile {
	RFCreateProfileViewController *controller = [[RFCreateProfileViewController alloc] initWithNibName:@"RFCreateProfileViewController" bundle:nil];
	
	// Create navigation controller and adjust tint color
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
	navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	// Create cancel button and assign it
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissModal)];
	controller.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	
	// Present controller and release it
	[self presentModalViewController:navigationController animated:YES];
	[controller release];
	[navigationController release];	

}

@end
