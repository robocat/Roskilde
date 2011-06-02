//
//  RFScheduleViewController.m
//  Roskilde
//
//  Created by Willi Wu on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFScheduleViewController.h"
#import "NSDateHelper.h"
#import "RFModelController.h"
#import "RFTimelineViewController.h"

@interface RFScheduleViewController ()

@property (nonatomic, retain) RFTimelineViewController *timelineViewController;

@end

@implementation RFScheduleViewController

@synthesize dateScroller;
@synthesize timelineScrollView;
@synthesize orangeButton;
@synthesize arenaButton;
@synthesize cosmopolButton;
@synthesize odeonButton;
@synthesize pavilionButton;
@synthesize timelineViewController;

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
	self.timelineScrollView.contentSize = CGSizeMake(1212.0f, 296.0f);
	
	RFDateScrollerViewController *scroller = [[RFDateScrollerViewController alloc] initWithNibName:@"RFDateScrollerViewController" bundle:nil];
	scroller.delegate = self;
	scroller.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, 66.0f);
	self.dateScroller = scroller;
	[self.view addSubview:scroller.view];
	[scroller release];
	
	// Set currentPageNumber to now date!
	currentPageNumber = 0;
	
	[self performSelector:@selector(animateAllScenes) withObject:nil afterDelay:0.1];
	
	self.timelineViewController = [[RFTimelineViewController alloc] init];
	self.timelineViewController.navigationController = self.navigationController;
	self.timelineViewController.view = timelineScrollView;
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
	CGFloat time = 1.0;
	
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
				date = [NSDate dateWithString:@"2011-06-26 11:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"];
				break;
			case 1:
				date = [NSDate dateWithString:@"2011-06-27 11:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"];
				break;
			case 2:
				date = [NSDate dateWithString:@"2011-06-28 11:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"];
				break;
			case 3:
				date = [NSDate dateWithString:@"2011-06-29 11:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"];
				break;
			case 4:
				date = [NSDate dateWithString:@"2011-06-30 11:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"];
				break;
			case 5:
				date = [NSDate dateWithString:@"2011-07-01 11:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"];
				break;
			case 6:
				date = [NSDate dateWithString:@"2011-07-02 11:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"];
				break;
			case 7:
				date = [NSDate dateWithString:@"2011-07-03 11:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"];
				break;
			default:
                date = [NSDate dateWithString:@"2011-07-01 11:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"];
				break;
		}
		
		[self.timelineViewController changeDate:date];
		
//		[self setupTimelineForDate:date scroll:YES];
	}
}

@end
