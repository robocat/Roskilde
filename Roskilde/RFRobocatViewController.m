//
//  RFRobocatViewController.m
//  Roskilde
//
//  Created by Willi Wu on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFRobocatViewController.h"
#import "RKCustomNavigationBar.h"
#import "SVWebViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "JSONKit.h"


@implementation RFRobocatViewController

@synthesize infoView;
@synthesize titleButton;
@synthesize starButton;
@synthesize websiteButton;
@synthesize itunesButton;
@synthesize artistLabel;
@synthesize playtimeLabel;
@synthesize descriptionTextView;
@synthesize msgLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[starButton release];
	[websiteButton release];
	[itunesButton release];
	[titleButton release];
	[artistLabel release];
	[playtimeLabel release];
	[infoView release];
	
	[descriptionTextView release];
	[msgLabel release];
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
    // Do any additional setup after loading the view from its nib.
	
	self.title = NSLocalizedString(@"About", @"");
	
	// Custom navbar
	RKCustomNavigationBar *navBar = (RKCustomNavigationBar*)self.navigationController.navigationBar;
	[navBar setBackgroundWith:[UIImage imageNamed:@"navbar.png"]];
	
	CGRect frame = self.infoView.frame;
	//	self.infoView.frame = CGRectMake(-frame.size.width, 40.0, frame.size.width, frame.size.height);
	self.infoView.frame = CGRectMake(0.0, 258.0, frame.size.width, frame.size.height);
	
	self.msgLabel.frame = CGRectMake(0.0, -32.0, 320.0, 32.0);
	
	// Artist label
	self.artistLabel.text = @"Robocat";
	self.descriptionTextView.text = @"hej";
	self.playtimeLabel.text = @"hello";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	
	[self performSelector:@selector(showInfoView) withObject:nil afterDelay:0.0];
	[self performSelector:@selector(fetchMessage) withObject:nil afterDelay:0.0];
}

- (void)viewDidUnload
{
	[self setStarButton:nil];
	[self setWebsiteButton:nil];
	[self setItunesButton:nil];
	[self setTitleButton:nil];
	[self setArtistLabel:nil];
	[self setPlaytimeLabel:nil];
	[self setInfoView:nil];
	[self setDescriptionTextView:nil];
	[self setMsgLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) showInfoView {
	CGRect frame = self.infoView.frame;
	frame.origin.y = 40.0;
	
	[UIView animateWithDuration:0.3 animations:^(void) {
		self.infoView.frame = frame;
	} completion:^(BOOL finished) {
	}];
}

- (IBAction)hideInfoView:(id)sender {
	CGRect frame = self.infoView.frame;
	frame.origin.y = 258.0;
	
	[UIView animateWithDuration:0.3 animations:^(void) {
		self.infoView.frame = frame;
	} completion:^(BOOL finished) {
	}];
}

- (IBAction)toggleInfoView:(id)sender {
	if (self.infoView.frame.origin.y == 40.0) {
		[UIView animateWithDuration:0.3 animations:^(void) {
			CGRect frame = self.infoView.frame;
			self.infoView.frame = CGRectMake(0.0, 258.0, frame.size.width, frame.size.height);
		} completion:^(BOOL finished) {
		}];
	}
	else {
		[UIView animateWithDuration:0.3 animations:^(void) {
			CGRect frame = self.infoView.frame;
			self.infoView.frame = CGRectMake(0.0, 40.0, frame.size.width, frame.size.height);
		} completion:^(BOOL finished) {
		}];
	}
}


- (IBAction) starButtonPressed:(id)sender {
	NSString *reviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=378065061";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
}

- (IBAction)websitePressed:(id)sender {
	SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:@"http://www.robocatapps.com/"];
	[self.navigationController pushViewController:webViewController animated:YES];
	[webViewController release];
}


- (IBAction) itunesButtonPressed:(id)sender {
	NSString *appsURL = @"itms-apps://itunes.com/apps/robocat";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:appsURL]];
}


- (CGSize) calculateHeightOfTextFromWidth:(NSString*)text font: (UIFont*)withFont width:(float)width linebreak:(UILineBreakMode)lineBreakMode{
	return [text sizeWithFont:withFont 
			constrainedToSize:CGSizeMake(width, FLT_MAX) 
				lineBreakMode:lineBreakMode];
}


- (void)fetchMessage {
	NSString *urlString = [NSString stringWithFormat:@"%@/msgfromrobocat", kXdkAPIBaseUrl];
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
		
		NSString *msg = [parsedData objectForKey:@"msg"];
		
		if (![msg isEqualToString:@""]) {
			self.msgLabel.text = msg;
			
			[UIView animateWithDuration:0.1 animations:^(void) {
				self.msgLabel.frame = CGRectMake(0.0, 0.0, 320.0, 32.0);
			} completion:^(BOOL finished) {
			}];
		}
		else {
			self.msgLabel.frame = CGRectMake(0.0, -32.0, 320.0, 32.0);
		}
	}];
	[request setFailedBlock:^{
		NSError *error = [request error];
		NSLog(@"error: %@", error);
	}];
	[request startAsynchronous];
}


@end
