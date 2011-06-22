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
#import "CamViewController.h"
#import "CamDevice.h"
#import "ASIFormDataRequest.h"
#import "SHK.h"


#define kImageDisplayWidth		120.0
#define kImageDisplayHeight		90.0
#define kImageDownloadWidth		320.0
#define kImageDownloadHeight	240.0

#define kStatsBarHieght		30.0
#define kAuthMinHieght		64.0

#define kRowOffset			2

#define kStatusBarHeight 20
#define kDefaultToolbarHeight 40
#define kKeyboardHeightPortrait 216
#define kKeyboardHeightLandscape 140

#define kToolbarY			376.0


@interface RFPictureDetailTableViewController ()
- (void)setImageUrl:(NSString*)url size:(CGSize)size dlsize:(CGSize)dlsize;
@end


@implementation RFPictureDetailTableViewController

@synthesize entry = _entry;
@synthesize replies = _replies;
@synthesize zoomingView;
@synthesize imageView;
@synthesize toolbar;
@synthesize inputToolbar;
@synthesize toolbarImageView;
@synthesize cameraButton;
@synthesize inputButton;
@synthesize likeButton;


//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)dealloc
{
	[fullscreenViewController release];
	self.entry = nil;
	self.replies = nil;
	
	[imageView release];
	
	self.inputToolbar = nil;
	self.toolbar = nil;
    self.cameraButton = nil;
    self.inputButton = nil;
    self.likeButton = nil;
	
	[toolbarImageView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

//- (void)awakeFromNib {
//	[super awakeFromNib];
//	
//	//	self.entries = [[NSMutableArray alloc] init];
//}

- (void)loadView {
	[super loadView];

	self.zoomingView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 240)] autorelease];
	self.zoomingView.clipsToBounds = YES;
	
	self.imageView = [[[FLImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 240)] autorelease];
	self.imageView.contentMode = UIViewContentModeScaleAspectFill;
	self.imageView.userInteractionEnabled = YES;
	[self.zoomingView addSubview:self.imageView];
	
	fullscreenViewController = [[FullscreenViewController alloc] init];
//	fullscreenViewController.view = [[self.zoomingView subviews] objectAtIndex:0];
	fullscreenViewController.view = self.imageView;
	fullscreenViewController.delegate = self;
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
	
	// Custom navbar
	RKCustomNavigationBar *navBar = (RKCustomNavigationBar*)self.navigationController.navigationBar;
	[navBar setBackgroundWith:[UIImage imageNamed:@"altnavbar.png"]];
	
	// Create action button and assign it
	UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
	self.navigationItem.rightBarButtonItem = actionButton;
	[actionButton release];
	
	NSDictionary *author = [self.entry objectForKey:@"created_by"];
	NSString *username = [author objectForKey:@"username"];
	
	[self setWhiteTitle:[NSString stringWithFormat:@"%@'s Picture", username]];
	
	
	
	self.tableView.frame = CGRectMake(0.0, 0.0, 320, kToolbarY);
	
	
	keyboardIsVisible = NO;

	/* Create toolbar */
	self.inputToolbar = [[[UIInputToolbar alloc] initWithFrame:CGRectMake(0, kToolbarY, self.view.frame.size.width, kDefaultToolbarHeight)] autorelease];
	[self.view addSubview:self.inputToolbar];
	self.inputToolbar.delegate = self;
	
	
	// Toolbar
	self.toolbar = [[[UIView alloc] initWithFrame:CGRectMake(0.0, kToolbarY, 320.0, 44.0)] autorelease];
//	self.toolbar.userInteractionEnabled = NO;
	[self.view addSubview:self.toolbar];
	
	self.toolbarImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"commentbox.png"]] autorelease];
	[self.toolbar addSubview:self.toolbarImageView];
	
	self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.cameraButton.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
	[self.cameraButton addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.toolbar addSubview:self.cameraButton];
	
	self.inputButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.inputButton.frame = CGRectMake(44.0, 0.0, 200.0, 44.0);
	[self.inputButton addTarget:self action:@selector(replyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.toolbar addSubview:self.inputButton];
	
	self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.likeButton.frame = CGRectMake(244.0, 0.0, 76.0, 44.0);
	[self.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.toolbar addSubview:self.likeButton];

//	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//																		 action:@selector(dismissKeyboard)];
//    [self.tableView addGestureRecognizer:tap];

	[self performSelector:@selector(refresh) withObject:nil afterDelay:0.0];
}

- (void)viewDidUnload
{
	[self setImageView:nil];
	[self setLikeButton:nil];
	[self setToolbarImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	self.zoomingView = nil;
	
	self.inputToolbar = nil;
	self.toolbar = nil;
	self.cameraButton = nil;
    self.inputButton = nil;
    self.likeButton = nil;
}

- (void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
	/* Listen for keyboard */
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
	/* No longer listen for keyboard */
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
		return 240.0;
	}
	else if (indexPath.row == 1)
	{
		NSString *comment = [self.entry objectOrEmptyStringForKey:@"comment"];
		CGSize commentSize = [comment sizeWithFont:[UIFont boldSystemFontOfSize:12]
								 constrainedToSize:CGSizeMake(200.0f, FLT_MAX)
									 lineBreakMode:UILineBreakModeTailTruncation];
		
		CGFloat height = commentSize.height + kAuthMinHieght;
		
		if (height > kAuthMinHieght + kStatsBarHieght)
			return height;
		else
			return kAuthMinHieght + kStatsBarHieght;
	}
	else if (indexPath.row > 1)
	{
		CGFloat minHeight = kAuthMinHieght;
		NSDictionary *reply = [self.replies objectAtIndex:(indexPath.row - kRowOffset)];
		NSString *comment = [reply objectOrEmptyStringForKey:@"comment"];
		NSString *imageUrl			= [reply objectOrEmptyStringForKey:@"image_url"];
		BOOL hasImage				= ![imageUrl isEqualToString:@""];
		
		CGSize commentSize;
		CGFloat height;
		
		if (hasImage) {
			commentSize = [comment sizeWithFont:[UIFont boldSystemFontOfSize:12]
							  constrainedToSize:CGSizeMake(110.0f, FLT_MAX)
								  lineBreakMode:UILineBreakModeTailTruncation];
			
			minHeight += 80.0;
			height = commentSize.height + minHeight;
		}
		else {
			commentSize = [comment sizeWithFont:[UIFont boldSystemFontOfSize:12]
							  constrainedToSize:CGSizeMake(200.0f, FLT_MAX)
								  lineBreakMode:UILineBreakModeTailTruncation];
			
			height = commentSize.height + kAuthMinHieght;
		}
		
		
		
		if (height >= minHeight)
			return height;
	}
	
	return kAuthMinHieght;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.replies count] + kRowOffset;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 50.0)];
	label.backgroundColor = [UIColor clearColor];
	label.text = @"";
	
	return [label autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 50.0;
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


- (CGFloat) entryHeightWithWidth:(CGFloat)width height:(CGFloat)height {
	float defaultWidth = kImageDownloadWidth;
	if (width == 0)
		width = 640;
	if (height == 0)
		height = 480;
	
	return (defaultWidth / ((float)width / (float)height));
}

- (void)configureCell:(UITableViewCell *)cell_
          atIndexPath:(NSIndexPath*)indexPath {
	
	ReplyTableViewCell * cell	= (ReplyTableViewCell *)cell_;
	
	NSDictionary *reply = [self.replies objectAtIndex:indexPath.row - kRowOffset];
	
	NSDictionary *author		= [reply objectForKey:@"created_by"];
	cell.author					= [author objectOrEmptyStringForKey:@"fullname"];
	cell.creationDate			= [NSDate localDateFromUTCFormattedDate:[NSDate dateWithDateTimeString:[reply objectForKey:@"created_at"]]];
	cell.comment				= [reply objectOrEmptyStringForKey:@"comment"];
	
	NSString *imageUrl			= [reply objectOrEmptyStringForKey:@"image_url"];
	BOOL hasImage				= ![imageUrl isEqualToString:@""];
	cell.hasImage				= hasImage;
	
	[cell setAvatarUrl:[author objectForKey:@"avatar_url"] size:CGSizeMake(44.0, 44.0)];
	
	if (hasImage) {
		int width	= [[reply objectForKey:@"width"] intValue];
		int height	= [[reply objectForKey:@"height"] intValue];
		CGFloat dlHeight = [self entryHeightWithWidth:width height:height];
		
		[cell setImageUrl:[reply objectForKey:@"image_url"]
					 size:CGSizeMake(kImageDisplayWidth, kImageDisplayHeight)
				   dlsize:CGSizeMake(kImageDownloadWidth, dlHeight)];
	}
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
			cell = (AuthorTableViewCell *)[[[AuthorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AuthorCellIdentifier] autorelease];
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row > kRowOffset-1) {
		NSDictionary *reply = [self.replies objectAtIndex:indexPath.row-kRowOffset];
		NSString *imageUrl			= [reply objectOrEmptyStringForKey:@"image_url"];
		BOOL hasImage				= ![imageUrl isEqualToString:@""];
		
		if (hasImage) {
			RFPictureDetailTableViewController *detailViewController = [[RFPictureDetailTableViewController alloc] init];
			detailViewController.entry = [self.replies objectAtIndex:indexPath.row-kRowOffset];
			detailViewController.hidesBottomBarWhenPushed = YES;
			[self.navigationController pushViewController:detailViewController animated:YES];
			[detailViewController release];
		}
	}
}



#pragma mark - PullToRefreshAppDelegate Methods

- (void)refreshRequestedForTableView:(UITableView *)tableView {
	[self performSelector:@selector(fetchEntry) withObject:nil afterDelay:0.0];
}

- (void)refresh {
    [self performSelector:@selector(fetchEntry) withObject:nil afterDelay:0.0];
	[self performSelector:@selector(checkLike) withObject:nil afterDelay:0.0];
}

- (void)refreshDone {
	self.tableView.scrollEnabled = YES;
	[self.tableView reloadData];
//	[self stopLoading];
	[_pullToRefreshView stopLoading];
}


- (CGFloat) entryHeightWithWidth2:(CGFloat)width height:(CGFloat)height {
	float defaultWidth = self.imageView.bounds.size.width;
	if (width ==0)
		width = 640;
	if (height == 0)
		height = 480;
	
	return (defaultWidth / ((float)width / (float)height));
}


- (void)fetchEntry {
	self.tableView.scrollEnabled = NO;
	
	int width	= [[self.entry objectForKey:@"width"] intValue];
	int height	= [[self.entry objectForKey:@"height"] intValue];
	CGFloat dlHeight = [self entryHeightWithWidth2:width height:height];
	
	[self setImageUrl:[self.entry objectForKey:@"image_url"]
				 size:CGSizeMake(self.imageView.bounds.size.width, self.imageView.bounds.size.height)
			   dlsize:CGSizeMake(self.imageView.bounds.size.width, dlHeight)];
	
	
	NSString *urlString = [NSString stringWithFormat:@"%@/entries/%@", kXdkAPIBaseUrl, [self.entry objectForKey:@"entry_id"]];
	NSURL *url = [NSURL URLWithString:urlString];
	__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    // Disabling secure certificate validation
    [request setValidatesSecureCertificate:NO];
    
	[request setDownloadCache:[ASIDownloadCache sharedCache]];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	[request setSecondsToCache:3600];
	
	[request setCompletionBlock:^{
		// Use when fetching text data
		NSString *responseString = [request responseString];
		
		// JSONKit parse
		id parsedData = [responseString objectFromJSONString];
		NSDictionary *entryDict = [parsedData objectForKey:@"entry"];
		NSMutableArray *repliesArray = [parsedData objectForKey:@"replies"];
		
		
		self.entry = nil;
		self.entry = [[[NSDictionary alloc] initWithDictionary:entryDict] autorelease];
		
		self.replies = nil;
		//		[self.entries addObjectsFromArray:parsedData];
		self.replies = [[[NSMutableArray alloc] initWithArray:repliesArray] autorelease];
		
		[self refreshDone];
	}];
	[request setFailedBlock:^{
		NSError *error = [request error];
		NSLog(@"error: %@", error);
		
		[[[[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"Your internet connection is weak. Have another beer, move around and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
		
		[self refreshDone];
	}];
	[request startAsynchronous];
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


- (void)cameraButtonPressed:(id)sender {
	if ([CamDevice hasCamera]) {
		CamViewController *camViewController = [[CamViewController alloc] initWithNibName:@"CamViewController" bundle:nil];
		camViewController.replyTo = [self.entry objectForKey:@"entry_key"];
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:camViewController];
		
		[navigationController setNavigationBarHidden:YES];
		
		[self presentModalViewController:navigationController animated:NO];
		[navigationController release];
		[camViewController release];
	} else {
		[[[[UIAlertView alloc] initWithTitle:@"No camera detected" message:@"This device doesn't have a camera" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
	}
}

- (void)replyButtonPressed:(id)sender {
	[self.inputToolbar.textView.internalTextView becomeFirstResponder];
}

- (void)likeButtonPressed:(id)sender {
	if (![RFGlobal username]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kPromptCreateProfile object:nil];
		return;
	}
	
	self.toolbarImageView.image = [UIImage imageNamed:@"commentbox_liked.png"];
	
	NSString *urlString = [NSString stringWithFormat:@"%@/entries/%@/like", kXdkAPIBaseUrl, [self.entry objectForKey:@"entry_id"]];
	NSURL *url = [NSURL URLWithString:urlString];
	
	__block ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:url];
    
    // Disabling secure certificate validation
    [formRequest setValidatesSecureCertificate:NO];
    
	formRequest.requestMethod = @"POST";
	
	// Basic Auth
	NSString *auth = [NSString stringWithFormat:@"Basic %@",[ASIHTTPRequest base64forData:[[NSString stringWithFormat:@"%@:%@", [RFGlobal username], [RFGlobal password]] dataUsingEncoding:NSUTF8StringEncoding]]];
	[formRequest addRequestHeader:@"Authorization" value:auth];
	
	[formRequest setCompletionBlock:^{
		// Use when fetching text data
		//			NSString *responseString = [formRequest responseString];
		int statusCode = [formRequest responseStatusCode];
		//			LOG_EXPR(statusCode);
		//			LOG_EXPR(responseString);
		
		if (statusCode == 200 || statusCode == 201) {
			// Liked
			
			// Use when fetching text data
			NSString *responseString = [formRequest responseString];
			
			// JSONKit parse
			id parsedData = [responseString objectFromJSONString];
			
			self.toolbarImageView.image = nil;
			
			if ([[parsedData objectForKey:@"liked"] boolValue] == YES) {
				self.toolbarImageView.image = [UIImage imageNamed:@"commentbox_liked.png"];
			}
			else {
				self.toolbarImageView.image = [UIImage imageNamed:@"commentbox.png"];
			}
			
			[self fetchEntry];
		}
		else {
		}
	}];
	
	[formRequest setFailedBlock:^{
		NSError *error = [formRequest error];
		NSLog(@"error: %@", error);
		
		[[[[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"Your internet connection is weak. Have another beer, move around and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
		
		self.toolbarImageView.image = [UIImage imageNamed:@"commentbox.png"];
	}];
	
	[formRequest startAsynchronous];
}



- (void)checkLike {
	if (![RFGlobal username]) {
		return;
	}
	
	NSString *urlString = [NSString stringWithFormat:@"%@/entries/%@/like", kXdkAPIBaseUrl, [self.entry objectForKey:@"entry_id"]];
	NSURL *url = [NSURL URLWithString:urlString];
	
	__block ASIHTTPRequest *formRequest = [ASIHTTPRequest requestWithURL:url];
    
    // Disabling secure certificate validation
    [formRequest setValidatesSecureCertificate:NO];
    
    // Set timeout to 30 secs
    [formRequest setTimeOutSeconds:30];
    
	formRequest.requestMethod = @"GET";
	
	// Basic Auth
	NSString *auth = [NSString stringWithFormat:@"Basic %@",[ASIHTTPRequest base64forData:[[NSString stringWithFormat:@"%@:%@", [RFGlobal username], [RFGlobal password]] dataUsingEncoding:NSUTF8StringEncoding]]];
	[formRequest addRequestHeader:@"Authorization" value:auth];
	
	[formRequest setCompletionBlock:^{
		// Use when fetching text data
		//			NSString *responseString = [formRequest responseString];
		int statusCode = [formRequest responseStatusCode];
		//			LOG_EXPR(statusCode);
		//			LOG_EXPR(responseString);
		
		self.toolbarImageView.image = nil;
		
		if (statusCode == 200 || statusCode == 201) {
			// Liked
			self.toolbarImageView.image = [UIImage imageNamed:@"commentbox_liked.png"];
		}
		else {
			// No
			self.toolbarImageView.image = [UIImage imageNamed:@"commentbox.png"];
		}
	}];
	
	[formRequest setFailedBlock:^{
		NSError *error = [formRequest error];
		NSLog(@"error: %@", error);
		
	}];
	
	[formRequest startAsynchronous];
}



//-(void)dismissKeyboard {
//    if([self.inputToolbar.textView.internalTextView isFirstResponder])
//		[self.inputToolbar.textView.internalTextView resignFirstResponder];
//}


#pragma mark -
#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification 
{
	[self.view bringSubviewToFront:self.inputToolbar];
	
    /* Move the toolbar to above the keyboard */
	[UIView animateWithDuration:0.3 animations:^(void) {
		CGRect frame = self.inputToolbar.frame;
		if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
			frame.origin.y = self.view.frame.size.height - frame.size.height - kKeyboardHeightPortrait;
		}
		else {
			frame.origin.y = self.view.frame.size.width - frame.size.height - kKeyboardHeightLandscape - kStatusBarHeight;
		}
		self.inputToolbar.frame = frame;
		
		self.tableView.frame = CGRectMake(0.0, 0.0, 320, frame.origin.y);

	} completion:^(BOOL finished) {
		
	}];
	
	
    keyboardIsVisible = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification 
{
    /* Move the toolbar back to bottom of the screen */
	[UIView animateWithDuration:0.3 animations:^(void) {
		CGRect frame = self.inputToolbar.frame;
		if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
			frame.origin.y = self.view.frame.size.height - frame.size.height;
		}
		else {
			frame.origin.y = self.view.frame.size.width - frame.size.height;
		}
		self.inputToolbar.frame = frame;
		
		self.tableView.frame = CGRectMake(0.0, 0.0, 320, kToolbarY);
		
		[UIView commitAnimations];
		keyboardIsVisible = NO;
	} completion:^(BOOL finished) {
		[self.view bringSubviewToFront:self.toolbar];
	}];
}

-(void)inputButtonPressed:(NSString *)inputText
{
    /* Called when toolbar button is pressed */
//    NSLog(@"Pressed button with text: '%@'", inputText);
	
	if (![RFGlobal username]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kPromptCreateProfile object:nil];
		return;
	}
	
	if (![inputText isEqualToString:@""]) {
		NSString *urlString = [NSString stringWithFormat:@"%@/entries/%@/replies", kXdkAPIBaseUrl, [self.entry objectForKey:@"entry_id"]];
		NSURL *url = [NSURL URLWithString:urlString];
		
		// Prepare data
		NSString *comment = (inputText) ? inputText : (NSString *)[NSNull null];
		NSString *loc = (NSString *)[NSNull null];
		
		NSMutableDictionary *data = [NSMutableDictionary dictionaryWithCapacity:6];
		[data setObject:[RFGlobal username] forKey:@"username"];
		[data setObject:[RFGlobal password] forKey:@"password"];
		[data setObject:comment forKey:@"comment"];
		[data setObject:loc forKey:@"location"];
		[data setObject:@"Roskilde app" forKey:@"via"];
		[data setObject:[self.entry objectForKey:@"entry_key"] forKey:@"reply_to"];
		
		NSString *json = [data JSONString];
		
		__block ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:url];
        
        // Disabling secure certificate validation
        [formRequest setValidatesSecureCertificate:NO];
        
		[formRequest setPostValue:json forKey:@"data"];
		
		// Basic Auth
		NSString *auth = [NSString stringWithFormat:@"Basic %@",[ASIHTTPRequest base64forData:[[NSString stringWithFormat:@"%@:%@", [RFGlobal username], [RFGlobal password]] dataUsingEncoding:NSUTF8StringEncoding]]];
		[formRequest addRequestHeader:@"Authorization" value:auth];
		
		[formRequest setCompletionBlock:^{
			// Use when fetching text data
//			NSString *responseString = [formRequest responseString];
//			int statusCode = [formRequest responseStatusCode];
//			LOG_EXPR(statusCode);
//			LOG_EXPR(responseString);
			
			[self fetchEntry];
		}];
		
		[formRequest setFailedBlock:^{
			NSError *error = [formRequest error];
			NSLog(@"error: %@", error);
			
			[[[[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"Your internet connection is weak. Have another beer, move around and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
		}];
		
		[formRequest startAsynchronous];
	}
}


- (void)dismissTextInput {
	self.inputToolbar.textView.internalTextView.text = @"";
	[self.inputToolbar.textView clearText];
	[self.inputToolbar.textView resignFirstResponder];
//	[self.inputToolbar.textView.internalTextView resignFirstResponder];
}


- (void)share:(id)sender
{
	NSDictionary *author = [self.entry objectForKey:@"created_by"];
	NSString *fullname = [author objectForKey:@"fullname"];
	NSString *title = [NSString stringWithFormat:@"See %@'s picture from Roskilde Festival", fullname];
	NSString *link = [self.entry objectForKey:@"shorturl"];
	NSString *imgUrl = [self.entry objectForKey:@"image_url"];
	
//	SHKItem *item = [SHKItem URL:[NSURL URLWithString:link] title:title];
//	NSString *text = [NSString stringWithFormat:@"%@ %@", title, link];
//	
//	SHKItem *item = [SHKItem text:text];
	
	SHKItem *item = [SHKItem URL:[NSURL URLWithString:link] imageURL:imgUrl title:title];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	[actionSheet showFromToolbar:self.navigationController.toolbar]; 
}


@end
