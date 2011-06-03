//
//  RFConcertDetailViewController.m
//  Roskilde
//
//  Created by Willi Wu on 26/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFConcertDetailViewController.h"
#import "RKCustomNavigationBar.h"
#import "RFMusic.h"
#import "NSDateHelper.h"
#import "RFModelController.h"
#import "SVWebViewController.h"


@interface RFConcertDetailViewController ()
- (CGSize) calculateHeightOfTextFromWidth:(NSString*)text font: (UIFont*)withFont width:(float)width linebreak:(UILineBreakMode)lineBreakMode;
@end



@implementation RFConcertDetailViewController

@synthesize concert = _concert;
@synthesize infoView;
@synthesize titleButton;
@synthesize starButton;
@synthesize websiteButton;
@synthesize itunesButton;
@synthesize artistLabel;
@synthesize playtimeLabel;
@synthesize genreImageView;
@synthesize sceneImageView;
@synthesize descriptionTextView;
@synthesize artistImage;

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
	self.concert = nil;
	
	[starButton release];
	[websiteButton release];
	[itunesButton release];
	[titleButton release];
	[artistLabel release];
	[playtimeLabel release];
	[infoView release];
	
	[descriptionTextView release];
	[genreImageView release];
	[sceneImageView release];
    [artistImage release];
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
	
	
	self.title = self.concert.artist;
	
	NSString *imgName = [NSString stringWithFormat:@"%@.jpg", self.concert.artistId];
	self.artistImage.image = [UIImage imageNamed:imgName];
	
//	CGRect sceneFrame = self.sceneImageView.frame;
//	
//	if (self.concert.genre) {
//		NSString *imageName = [NSString stringWithFormat:@"%@.png", self.concert.genre];
//		self.genreImageView.image = [UIImage imageNamed:imageName];
//		[self.genreImageView sizeToFit];
//		
//		sceneFrame.origin.x = self.genreImageView.frame.origin.x + self.genreImageView.frame.size.width + 5.0;
//	}
//	else {
//		CGRect sceneFrame = self.sceneImageView.frame;
//		sceneFrame.origin.x = 5.0;
//	}
//	
//	self.sceneImageView.frame = sceneFrame;
//	
//	CGRect playtimeFrame = self.playtimeLabel.frame;
//	playtimeFrame.origin.x = sceneFrame.origin.x + sceneFrame.size.width + 5.0;
//	self.playtimeLabel.frame = playtimeFrame;
	
	
	// Genre
	
	NSString * genreString = nil;
	if (![self.concert.genre isEqualToString:@""]) {
		genreString = [NSString stringWithFormat:@"%@.png", self.concert.genre];
	}
	else {
		genreString = @"nogenre.png";
	}
	
	UIImage * genreImage = [UIImage imageNamed:genreString];
	self.genreImageView.image = genreImage;
	self.genreImageView.frame = CGRectMake(self.genreImageView.frame.origin.x,
										   self.genreImageView.frame.origin.y,
										   genreImage.size.width,
										   genreImage.size.height);
	// move venue and date
	self.sceneImageView.frame = CGRectMake(self.genreImageView.frame.origin.x + self.genreImageView.frame.size.width + 6.0f,
										   self.sceneImageView.frame.origin.y,
										   self.sceneImageView.frame.size.width,
										   self.sceneImageView.frame.size.height);
	
	// Date
//	self.playtimeLabel.text = [NSString stringWithFormat:@"%@, %@", [artist.beginDate formattedTimeStringForDisplay], [artist.beginDate formattedDateStringForDisplay]];
	self.playtimeLabel.frame = CGRectMake(self.sceneImageView.frame.origin.x + self.sceneImageView.frame.size.width + 6.0f,
										  self.playtimeLabel.frame.origin.y,
										  self.playtimeLabel.frame.size.width,
										  self.playtimeLabel.frame.size.height);
	
	
	
	if (self.concert.isFavoriteValue) {
		[self.starButton setImage:[UIImage imageNamed:@"button_starred.png"] forState:UIControlStateNormal];
	}
	
	// Artist label
	NSString * artistString = [self.concert.artist uppercaseString];
	
	CGSize size = [self calculateHeightOfTextFromWidth:artistString
												  font:[UIFont boldSystemFontOfSize:24]
												 width:artistLabel.frame.size.width
											 linebreak:UILineBreakModeTailTruncation];
	
	if (size.height > artistLabel.frame.size.height) {
		size = [self calculateHeightOfTextFromWidth:artistString
											   font:[UIFont boldSystemFontOfSize:16]
											  width:artistLabel.frame.size.width
										  linebreak:UILineBreakModeTailTruncation];
		
		if (size.height > artistLabel.frame.size.height) {
			artistLabel.font = [UIFont boldSystemFontOfSize:12];
		}
		else {
			artistLabel.font = [UIFont boldSystemFontOfSize:16];
		}
	}
	
	artistLabel.text = artistString;
	
	self.descriptionTextView.text = self.concert.descriptionText;
	self.playtimeLabel.text = [self.concert.beginDate formattedDate];
	self.websiteButton.hidden = ([self.concert.web isEqualToString:@""]);
	self.itunesButton.hidden = ([self.concert.itunes isEqualToString:@""]);
	
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
	[self setGenreImageView:nil];
	[self setSceneImageView:nil];
    [self setArtistImage:nil];
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

- (IBAction)favorite:(id)sender {
	self.concert.isFavoriteValue = !self.concert.isFavoriteValue;
	
	if (self.concert.isFavoriteValue) {
		[self.starButton setImage:[UIImage imageNamed:@"button_starred.png"] forState:UIControlStateNormal];
	}
	else {
		[self.starButton setImage:[UIImage imageNamed:@"button_starit.png"] forState:UIControlStateNormal];
	}
	
	[[RFModelController defaultModelController] save];
}

- (IBAction)websitePressed:(id)sender {
	SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:self.concert.web];
	[self.navigationController pushViewController:webViewController animated:YES];
	[webViewController release];
}

- (IBAction)itunesPressed:(id)sender {
	
}


- (CGSize) calculateHeightOfTextFromWidth:(NSString*)text font: (UIFont*)withFont width:(float)width linebreak:(UILineBreakMode)lineBreakMode{
	return [text sizeWithFont:withFont 
			constrainedToSize:CGSizeMake(width, FLT_MAX) 
				lineBreakMode:lineBreakMode];
}

@end
