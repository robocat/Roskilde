//
//  RFScheduleViewController.m
//  Roskilde
//
//  Created by Willi Wu on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFScheduleViewController.h"
#import "NSDateHelper.h"
#import "NSDate+Helper.h"
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
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[pageBeginDates release];
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
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToNow:) 
												 name:kMusicDataImported object:nil];
	
	self.title = NSLocalizedString(@"Schedule", @"");
	
	UIBarButtonItem *nowButton = [[UIBarButtonItem alloc] initWithTitle:@"Now" style:UIBarButtonItemStyleBordered target:self action:@selector(jumpToNow:)];
	self.navigationItem.leftBarButtonItem = nowButton;
	[nowButton release];
	
	
	pageBeginDates = [[NSArray alloc] initWithObjects:
					  [NSDate dateWithString:@"2011-06-26 11:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"],
					  [NSDate dateWithString:@"2011-06-27 11:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"],
					  [NSDate dateWithString:@"2011-06-28 11:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"],
					  [NSDate dateWithString:@"2011-06-29 11:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"],
					  [NSDate dateWithString:@"2011-06-30 11:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"],
					  [NSDate dateWithString:@"2011-07-01 11:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"],
					  [NSDate dateWithString:@"2011-07-02 11:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"],
					  [NSDate dateWithString:@"2011-07-03 11:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"], nil];
	
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
	
	[self performSelector:@selector(jumpToCurrentDate) withObject:nil afterDelay:0.0];
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

- (CGFloat) widthBetweenDate:(NSDate *)bDate andDate:(NSDate *)eDate {
	return ([eDate timeIntervalSinceDate:bDate] / 60.0f) + 11; // 11 pixels extra for 11:00
}

- (void)jumpToDate:(NSDate *)aDate {
	NSDate * date = [pageBeginDates objectAtIndex:currentPageNumber];
	CGFloat x = [self widthBetweenDate:date andDate:aDate];
	
	[self.timelineScrollView scrollRectToVisible:CGRectMake(x, 0, 320, 296) animated:YES];
}

- (void)jumpToCurrentDate {
	NSDate * date;
	
	switch (currentPageNumber) {
		case 0:
			date = [NSDate dateWithString:@"2011-06-26 13:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"];
			break;
		case 1:
			date = [NSDate dateWithString:@"2011-06-27 13:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"];
			break;
		case 2:
			date = [NSDate dateWithString:@"2011-06-28 13:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"];
			break;
		case 3:
			date = [NSDate dateWithString:@"2011-06-29 13:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"];
			break;
		case 4:
			date = [NSDate dateWithString:@"2011-06-30 15:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"];
			break;
		case 5:
			date = [NSDate dateWithString:@"2011-07-01 09:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"];
			break;
		case 6:
			date = [NSDate dateWithString:@"2011-07-02 09:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"];
			break;
		case 7:
			date = [NSDate dateWithString:@"2011-07-03 09:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"];
			break;
		default:
			date = [NSDate dateWithString:@"2011-07-01 09:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"];
			break;
	}
	
	[self jumpToDate:date];
}

- (void) dateScrollview:(RFDateScrollerViewController *)scollview didSwitchToPage:(NSUInteger)page {
	if (currentPageNumber != page) {
		currentPageNumber = page;
		
		NSDate * date = [pageBeginDates objectAtIndex:page];
		[self.timelineViewController changeDate:date];
		
		[self jumpToCurrentDate];
	}
}

- (NSInteger)pageForDate:(NSDate *)date {
	NSDate *beginDate = [pageBeginDates objectAtIndex:0];
	NSDate *endDate = [[pageBeginDates lastObject] dateByAddingDays:1];
	
	if ([date compare:beginDate] <= NSOrderedSame) {
		return 0;
	}
	else if (![date isBetweenDate:beginDate andDate:endDate]) {
		return -1;
	}
	
	NSInteger page = 0;
	for (int i = 0; i < [pageBeginDates count]; i ++) {
		NSComparisonResult result = [date compare:[pageBeginDates objectAtIndex:i]];
		if (result > NSOrderedAscending) {
			page = i;
		}
		else {
			break;
		}
	}
	
	return page;
}

- (IBAction)jumpToNow:(id)sender {
	NSDate * now = [NSDate date];  //[NSDate dateFromString:@"2011-07-02 10:00:00"];
	
	NSInteger page = [self pageForDate:now];
	
	if (page > -1) {
		currentPageNumber = page;
		[self.dateScroller goToPage:page];
		[self.timelineViewController changeDate:[pageBeginDates objectAtIndex:page]];
		
		NSDate *newDate = [now dateByAddingHours:-3];
		[self performSelector:@selector(jumpToDate:) withObject:newDate afterDelay:0.0];
	}
}


@end
