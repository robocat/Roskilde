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
#import "AuthorTableViewCell.h"
#import "NSDictionaryHelper.h"
#import "NSDateHelper.h"
#import "ReplyTableViewCell.h"
#import "FullscreenViewController.h"


#define kStatsBarHieght		30.0
#define kAuthMinHieght		64.0

#define kRowOffset			2


@interface RFPictureDetailTableViewController ()
- (void)setImageUrl:(NSString*)url size:(CGSize)size dlsize:(CGSize)dlsize;
@end


@implementation RFPictureDetailTableViewController

@synthesize entry = _entry;
@synthesize replies = _replies;
@synthesize zoomingView;
@synthesize imageView;


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
	
	[imageView release];
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
	
	
	// Custom navbar
	RKCustomNavigationBar *navBar = (RKCustomNavigationBar*)self.navigationController.navigationBar;
	[navBar setBackgroundWith:[UIImage imageNamed:@"sortbg.png"]];
	
	// Create action button and assign it
	UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActions:)];
	self.navigationItem.rightBarButtonItem = actionButton;
	[actionButton release];
	
	NSDictionary *author = [self.entry objectForKey:@"created_by"];
	NSString *username = [author objectForKey:@"username"];
	
	[self setWhiteTitle:[NSString stringWithFormat:@"%@'s Picture", username]];
	
	zoomingViewController = [[ZoomingViewController alloc] init];
	FullscreenViewController *fullscreenViewController = [[FullscreenViewController alloc] init];
	fullscreenViewController.view = [[zoomingView subviews] objectAtIndex:0];
//	zoomingViewController.view = zoomingView;
	
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
	[self setImageView:nil];
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
	else if (indexPath.row == 1)
	{
		return kStatsBarHieght + kAuthMinHieght;
	}
	else {
		return kAuthMinHieght;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.replies count] + kRowOffset;
}


- (void)configureAuthorCell:(UITableViewCell *)cell_
          atIndexPath:(NSIndexPath*)indexPath {
	
	AuthorTableViewCell * cell	= (AuthorTableViewCell *)cell_;
	
	NSDictionary *author		= [self.entry objectForKey:@"created_by"];
	cell.author					= [author objectOrEmptyStringForKey:@"fullname"];
	
	cell.location				= [self.entry objectOrEmptyStringForKey:@"location"];
	cell.creationDate			= [NSDate localDateFromUTCFormattedDate:[NSDate dateWithDateTimeString:[self.entry objectForKey:@"created_at"]]];
	cell.imageReplies			= [[self.entry objectForKey:@"image_replies_count"] intValue];
	cell.views					= [[self.entry objectForKey:@"views_count"] intValue];
	cell.replies				= [[self.entry objectForKey:@"comment_replies_count"] intValue];
	cell.likes					= [[self.entry objectForKey:@"likers"] count];
	cell.comment				= [self.entry objectOrEmptyStringForKey:@"comment"];
	
	[cell setAvatarUrl:[author objectForKey:@"avatar_url"] size:CGSizeMake(44.0, 44.0)];
}


- (void)configureCell:(UITableViewCell *)cell_
          atIndexPath:(NSIndexPath*)indexPath {
	
	ReplyTableViewCell * cell	= (ReplyTableViewCell *)cell_;
	
	NSDictionary *reply = [self.replies objectAtIndex:indexPath.row - kRowOffset];
	
	NSDictionary *author		= [reply objectForKey:@"created_by"];
	cell.author					= [author objectOrEmptyStringForKey:@"fullname"];
	cell.creationDate			= [NSDate localDateFromUTCFormattedDate:[NSDate dateWithDateTimeString:[reply objectForKey:@"created_at"]]];
	cell.comment				= [reply objectOrEmptyStringForKey:@"comment"];
	
	[cell setAvatarUrl:[author objectForKey:@"avatar_url"] size:CGSizeMake(44.0, 44.0)];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *FirstCellIdentifier = @"FirstCell";
	static NSString *AuthorCellIdentifier = @"AuthorCell";
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
	else if (indexPath.row == 1)
	{
		cell = (AuthorTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AuthorCellIdentifier];
		if (cell == nil) {
			cell = (AuthorTableViewCell *)[[[AuthorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstCellIdentifier] autorelease];
		}
		
		[self configureAuthorCell:cell atIndexPath:indexPath];
	}
	else
	{
		cell = (ReplyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = (ReplyTableViewCell *)[[[ReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
		[self configureCell:cell atIndexPath:indexPath];
	}
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

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


- (CGFloat) entryHeightWithWidth:(CGFloat)width height:(CGFloat)height {
	float defaultWidth = self.imageView.bounds.size.width;
	if (width == 0)
		width = 640;
	if (height == 0)
		height = 480;
	
	return (defaultWidth / ((float)width / (float)height));
}

- (void)fetchReplies {
	
	int width	= [[self.entry objectForKey:@"width"] intValue];
	int height	= [[self.entry objectForKey:@"height"] intValue];
	CGFloat dlHeight = [self entryHeightWithWidth:width height:height];
	
	[self setImageUrl:[self.entry objectForKey:@"image_url"]
				 size:CGSizeMake(self.imageView.bounds.size.width, self.imageView.bounds.size.height)
			   dlsize:CGSizeMake(self.imageView.bounds.size.width, dlHeight)];

	
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


- (void) showActions:(id)sender {
	
}


- (void)setImageUrl:(NSString*)url
			   size:(CGSize)size
			 dlsize:(CGSize)dlsize {
	
	if (self.imageView) {
		self.imageView.image = nil;
	}
	
	self.imageView.contentMode = UIViewContentModeScaleAspectFill;
//	self.imageView.clipsToBounds = YES;
	
	CGFloat scale = ([[UIScreen mainScreen] respondsToSelector:@selector (scale)] ? [[UIScreen mainScreen] scale] : 1);
	
	float maxsize = round(MAX(dlsize.width, dlsize.height));
	
	UIImage * placeholder = [UIImage imageNamed:@"xbg.png"];
	NSString *urlString = [NSString stringWithFormat:@"%@=s%.f", url, maxsize * scale];
	
	[self.imageView loadImageAtURLString:urlString placeholderImage:placeholder];
}

@end
