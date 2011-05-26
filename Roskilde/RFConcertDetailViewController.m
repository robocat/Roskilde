//
//  RFConcertDetailViewController.m
//  Roskilde
//
//  Created by Willi Wu on 26/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFConcertDetailViewController.h"
#import "RKCustomNavigationBar.h"


@implementation RFConcertDetailViewController
@synthesize infoView;
@synthesize titleButton;
@synthesize starButton;
@synthesize websiteButton;
@synthesize itunesButton;
@synthesize artistLabel;
@synthesize playtimeLabel;

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
	
	// Custom navbar
	RKCustomNavigationBar *navBar = (RKCustomNavigationBar*)self.navigationController.navigationBar;
	[navBar setBackgroundWith:[UIImage imageNamed:@"navbar.png"]];
	
	CGRect frame = self.infoView.frame;
//	self.infoView.frame = CGRectMake(-frame.size.width, 40.0, frame.size.width, frame.size.height);
	self.infoView.frame = CGRectMake(0.0, 258.0, frame.size.width, frame.size.height);
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

@end