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



@implementation RFRobocatViewController

@synthesize infoView;
@synthesize titleButton;
@synthesize starButton;
@synthesize websiteButton;
@synthesize itunesButton;
@synthesize artistLabel;
@synthesize playtimeLabel;
@synthesize descriptionTextView;

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
	
	
	// Artist label
	self.artistLabel.text = @"Robocat";
	self.descriptionTextView.text = @"hej";
	self.playtimeLabel.text = @"hello";
	
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	
	[self performSelector:@selector(showInfoView) withObject:nil afterDelay:0.0];
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
	NSString *templateReviewURL = @"https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=APP_ID&type=Purple+Software";
	NSString *reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%d", 378065061]];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
}

- (IBAction)websitePressed:(id)sender {
	SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:@"http://www.robocatapps.com/"];
	[self.navigationController pushViewController:webViewController animated:YES];
	[webViewController release];
}


- (IBAction) itunesButtonPressed:(id)sender {
	NSString *appsURL = @"http://itunes.com/apps/robocat";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:appsURL]];
}


- (CGSize) calculateHeightOfTextFromWidth:(NSString*)text font: (UIFont*)withFont width:(float)width linebreak:(UILineBreakMode)lineBreakMode{
	return [text sizeWithFont:withFont 
			constrainedToSize:CGSizeMake(width, FLT_MAX) 
				lineBreakMode:lineBreakMode];
}

@end
