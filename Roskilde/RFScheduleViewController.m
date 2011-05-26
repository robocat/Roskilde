//
//  RFScheduleViewController.m
//  Roskilde
//
//  Created by Willi Wu on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFScheduleViewController.h"
#import "NSDateHelper.h"


@implementation RFScheduleViewController

@synthesize dateScroller;
@synthesize timelineScrollView;
@synthesize orangeButton;
@synthesize arenaButton;
@synthesize cosmopolButton;
@synthesize odeonButton;
@synthesize pavilionButton;

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
	self.dateScroller = nil;
	self.timelineScrollView = nil;
	self.orangeButton = nil;
	self.arenaButton = nil;
	self.cosmopolButton = nil;
	self.odeonButton = nil;
	self.pavilionButton = nil;
	
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
	
	self.title = NSLocalizedString(@"Schedule", @"");
	
	self.timelineScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
	self.timelineScrollView.contentSize = CGSizeMake(1031.0f, 296.0f);
	
	RFDateScrollerViewController *scroller = [[RFDateScrollerViewController alloc] initWithNibName:@"RFDateScrollerViewController" bundle:nil];
	scroller.delegate = self;
	scroller.view.frame = CGRectMake(0.0f, 67.0f, 320.0f, 27.0f);
	self.dateScroller = scroller;
	[self.view addSubview:scroller.view];
	[scroller release];
	
	// Set currentPageNumber to now date!
	currentPageNumber = 0;
	
	[self performSelector:@selector(animateAllScenes) withObject:nil afterDelay:0.0];
}

- (void)viewDidUnload
{
    [self setOrangeButton:nil];
    [self setArenaButton:nil];
    [self setCosmopolButton:nil];
    [self setOdeonButton:nil];
    [self setPavilionButton:nil];
    [self setTimelineScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction) showSceneButton:(id)sender {
	UIButton * button = (UIButton *)sender;
	CGRect frame = button.frame;
	
	if (frame.origin.x == -120.0f) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		
		frame.origin.x += 120.0f;
		button.frame = frame;
		
		[UIView commitAnimations];
		
		[self performSelector:@selector(hideSceneButton:) withObject:button afterDelay:1.0];
	}
	else if (frame.origin.x == 0.0f) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		
		frame.origin.x -= 120.0f;
		button.frame = frame;
		
		[UIView commitAnimations];
	}
}

- (void) hideSceneButton:(UIButton *)button {
	CGRect frame = button.frame;
	
	if (frame.origin.x == 0.0f) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		
		frame.origin.x -= 120.0f;
		button.frame = frame;
		
		[UIView commitAnimations];
	}
}


- (void) animateAllScenes {
	CGFloat time = 1.5;
	
	[self performSelector:@selector(hideSceneButton:) withObject:self.orangeButton afterDelay:time];
	[self performSelector:@selector(hideSceneButton:) withObject:self.arenaButton afterDelay:time + 0.1];
	[self performSelector:@selector(hideSceneButton:) withObject:self.cosmopolButton afterDelay:time + 0.2];
	[self performSelector:@selector(hideSceneButton:) withObject:self.odeonButton afterDelay:time + 0.3];
	[self performSelector:@selector(hideSceneButton:) withObject:self.pavilionButton afterDelay:time + 0.4];
}


- (void) dateScrollview:(RFDateScrollerViewController *)scollview didSwitchToPage:(NSUInteger)page {
	if (currentPageNumber != page) {
		currentPageNumber = page;
		
		NSDate * date;
		
		switch (page) {
			case 0:
				date = [NSDate dateWithDateTimeString:@"2011-06-26 12:00:00"];
				break;
			case 1:
				date = [NSDate dateWithDateTimeString:@"2011-06-27 12:00:00"];
				break;
			case 2:
				date = [NSDate dateWithDateTimeString:@"2011-06-28 12:00:00"];
				break;
			case 3:
				date = [NSDate dateWithDateTimeString:@"2011-06-29 12:00:00"];
				break;
			case 4:
				date = [NSDate dateWithDateTimeString:@"2011-06-30 12:00:00"];
				break;
			case 5:
				date = [NSDate dateWithDateTimeString:@"2011-07-01 12:00:00"];
				break;
			case 6:
				date = [NSDate dateWithDateTimeString:@"2011-07-02 12:00:00"];
				break;
			case 7:
				date = [NSDate dateWithDateTimeString:@"2011-07-03 12:00:00"];
				break;
			default:
                date = [NSDate dateWithDateTimeString:@"2011-07-01 12:00:00"];
				break;
		}
		
//		[self setupTimelineForDate:date scroll:YES];
	}
}



@end
