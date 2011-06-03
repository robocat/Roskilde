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

#define kDataLimit				20


@interface RFPictureTableViewController ()
- (void)userLoggedIn;
@end



@implementation RFPictureTableViewController

@synthesize entries = _entries;
@synthesize spinner;
@synthesize showMyPictures;
@synthesize xbg;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		
    }
    return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[_entries release];
	self.entries = nil;
	self.spinner = nil;
	self.xbg = nil;
	
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
	
	showMyPictures = NO;
	
	//	self.entries = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoggedIn) 
												 name:kUserLoggedIn object:nil];
	
	self.title = NSLocalizedString(@"Pictures", @"");
	
	self.xbg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xbg.png"]] autorelease];
	CGRect xFrame = self.xbg.frame;
	xFrame.origin.y = -50;
	self.xbg.frame = xFrame;
	[self.view addSubview:self.xbg];
	
	self.entries = [[[NSMutableArray alloc] init] autorelease];
	loadedCount = 0;
	
//	self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xbg.png"]] autorelease];
	
	if ([RFGlobal username]) {
		[self userLoggedIn];
	}
	else {
		UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithTitle:@"Join the fun" style:UIBarButtonItemStyleBordered target:self action:@selector(createProfile)];
		self.navigationItem.leftBarButtonItem = createButton;
		[createButton release];
	}

	
	[self performSelector:@selector(refresh) withObject:nil afterDelay:0.0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	self.xbg = nil;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.entries count] + 1;
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
	
	if (indexPath.row == [self.entries count]) {
		return 50.0;
	}
	
	return kImageDisplayHeight + 100.0;
}

- (void)configureCell:(UITableViewCell *)cell_
          atIndexPath:(NSIndexPath*)indexPath {
	
	EntryTableViewCell * cell	= (EntryTableViewCell *)cell_;
	
	NSDictionary *entry = [self.entries objectAtIndex:indexPath.row];
	
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
	static NSString *LastCellIdentifier = @"LastCell";
	
	UITableViewCell * cell = nil;
	
	if (indexPath.row == [self.entries count])
	{
		cell = [tableView dequeueReusableCellWithIdentifier:LastCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		
		if (!spinner) {
			self.spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
			self.spinner.hidesWhenStopped = YES;
			self.spinner.center = cell.center;
			[cell addSubview:self.spinner];
		}
	}
	else {
		cell = (EntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[EntryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		[self configureCell:cell atIndexPath:indexPath];
	}
	
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
	if (!isLoading)
	{
		RFPictureDetailTableViewController *detailViewController = [[RFPictureDetailTableViewController alloc] init];
		detailViewController.entry = [self.entries objectAtIndex:indexPath.row];
		detailViewController.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
}



#pragma mark - Load More
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!isLoading
		&& loadedCount == kDataLimit
		&& indexPath.row == [self.entries count] - 2) {
		[self.spinner startAnimating];
		[self performSelector:@selector(fetchLiveFeed) withObject:nil afterDelay:0.0];
	}
}



#pragma mark - Fetch data

- (void)refresh {
	loadedCount = 0;
    [self performSelector:@selector(fetchLiveFeed) withObject:nil afterDelay:0.0];
}

- (void)refreshDone {
	if (self.xbg) {
		[UIView animateWithDuration:0.2 animations:^{
			self.xbg.alpha = 0;
		} completion:^(BOOL finished) {
			[self.xbg removeFromSuperview];
			self.xbg = nil;
		}];
	}
	
	[self.tableView reloadData];
	[self stopLoading];
	[self.spinner stopAnimating];
}

- (void)fetchLiveFeed {
	if (loadedCount == 0) {
		[self.entries removeAllObjects];
	}
	
	int page = [self.entries count] / kDataLimit + 1;
	
	NSString *urlString = nil;
	
	if (showMyPictures) {
		urlString = [NSString stringWithFormat:@"%@/entries/?page=%d&user=%@", kXdkAPIBaseUrl, page, [RFGlobal username]]; //?tags=roskilde-festival
	}
	else {
		urlString = [NSString stringWithFormat:@"%@/entries/?page=%d", kXdkAPIBaseUrl, page]; //?tags=roskilde-festival
	}
	
	NSURL *url = [NSURL URLWithString:urlString];
	__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//	[request setDownloadCache:[ASIDownloadCache sharedCache]];
//	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
//	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
//	[request setSecondsToCache:3600];
	
	[request setCompletionBlock:^{
		// Use when fetching text data
		NSString *responseString = [request responseString];
		
		// JSONKit parse
		id parsedData = [responseString objectFromJSONString];
		
		[self.entries addObjectsFromArray:parsedData];
//		self.entries = nil;
//		self.entries = [[[NSMutableArray alloc] initWithArray:parsedData] autorelease];
		
		loadedCount = [parsedData count];
		
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

- (void)myPicturesButtonPressed:(id)sender {
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"All Pictures" style:UIBarButtonItemStyleBordered target:self action:@selector(allPicturesButtonPressed:)];
	self.navigationItem.leftBarButtonItem = button;
	[button release];
	loadedCount = 0;
	showMyPictures = YES;
	[self refresh];
}

- (void)allPicturesButtonPressed:(id)sender {
	[self userLoggedIn];
	loadedCount = 0;
	showMyPictures = NO;
	[self refresh];
}

- (void)userLoggedIn {
	if ([RFGlobal username]) {
		UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"My Pictures" style:UIBarButtonItemStyleBordered target:self action:@selector(myPicturesButtonPressed:)];
		self.navigationItem.leftBarButtonItem = button;
		[button release];
	}
}

@end
