//
//  RFTimelineViewController.m
//  Roskilde
//
//  Created by Willi Wu on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFTimelineViewController.h"
#import "RFModelController.h"
#import "NSDateHelper.h"
#import "RFConcertDetailViewController.h"

@interface ConcertButton : UIButton 

@property (nonatomic, retain) RFMusic *music;

@end


@interface RFTimelineViewController ()

- (void)clearTimeLine;
- (void)drawTimeLine;

- (CGFloat) yForVenue:(NSString *)venue;
- (void)artistButtonPressed:(ConcertButton*)sender;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation RFTimelineViewController

@synthesize fetchedResultsController;
@synthesize navigationController;
@synthesize currentDate;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)setView:(UIView *)view {
	[super setView:view];
	
	NSError *error = nil;
	[[self fetchedResultsController] performFetch:&error];
	
	[self changeDate:[NSDate dateWithString:@"2011-06-26 11:00:00 GMT" formatString:@"yyyy-MM-dd HH:mm:ss ZZZ"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (CGFloat) yForVenue:(NSString *)venue {
	if ([venue isEqualToString:@"Pavilion Junior"]) {
		return 25;
	} else if ([venue isEqualToString:@"Pavilion"]) {
		return 25;
	} else if ([venue isEqualToString:@"Odeon"]) {
		return 80;
	} else if ([venue isEqualToString:@"Cosmopol"]) {
		return 135;
	} else if ([venue isEqualToString:@"Arena"]) {
		return 190;
	} else {
		return 245;
	}
}


- (void)clearTimeLine {
	for (UIView *view in [self.view subviews]) {
		if (view != [self.view.subviews objectAtIndex:0]) {
			[view removeFromSuperview];
		}
	}
}


- (void)changeDate:(NSDate*)newDate {
	self.currentDate = newDate;
	
	[self clearTimeLine];
	[self drawTimeLine];
}


- (void)drawTimeLine {
	NSDate *thisDay = self.currentDate;
	
	for (RFMusic *music in [fetchedResultsController fetchedObjects]) {
		NSDate *date = music.beginDate;
		
		if ([date timeIntervalSinceDate:thisDay] > 0 && [date timeIntervalSinceDate:thisDay] < 72000) {
			ConcertButton *button = [[ConcertButton buttonWithType:UIButtonTypeCustom] retain];
			button.frame = CGRectMake(([date timeIntervalSinceDate:thisDay]/3600)*60+11+.5, [self yForVenue:music.scene], music.durationValue, 50);
			button.music = music;
			[self.view addSubview:button];
			
			[button addTarget:self action:@selector(artistButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			
			CGRect labelFrame = CGRectMake(2.0f, 3.0f, button.frame.size.width - 4.0f, button.frame.size.height - 6.0f);
			UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
			label.textAlignment = UITextAlignmentCenter;
			label.numberOfLines = 0;
			label.text = music.artist;
			
			if (music.isFavoriteValue) {
				label.textColor = [UIColor colorWithWhite:0.103 alpha:1.000];
				label.shadowColor = [UIColor darkGrayColor];
				label.shadowOffset = CGSizeMake(0.0f, -1.0f);
				[button setBackgroundImage:[UIImage imageNamed:@"gigstar_container.png"] forState:UIControlStateNormal];
			} else {
				label.textColor = [UIColor whiteColor];
				label.shadowColor = [UIColor darkGrayColor];
				label.shadowOffset = CGSizeMake(0.0f, -1.0f);				
				[button setBackgroundImage:[UIImage imageNamed:@"gig_container.png"] forState:UIControlStateNormal];
			}
			
			label.font = [UIFont boldSystemFontOfSize:12];
			label.lineBreakMode = UILineBreakModeTailTruncation;
			label.backgroundColor = [UIColor clearColor];
			[button addSubview:label];
			[label release];
		}
	}
}


- (void)artistButtonPressed:(ConcertButton*)sender {
	RFMusic *music = sender.music;
	
	RFConcertDetailViewController *concertViewController = [[RFConcertDetailViewController alloc] init];
	concertViewController.concert = music;
	
	[self.navigationController pushViewController:concertViewController animated:YES];
	[concertViewController release];
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController*)fetchedResultsController  {
	if (fetchedResultsController) return fetchedResultsController;
	
	NSManagedObjectContext *managedObjectContext = [[[RFModelController defaultModelController] coreDataManager] managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Music" 
											  inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	[fetchRequest setFetchBatchSize:20];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"beginDate"
																   ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *frc = nil;
	frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
											  managedObjectContext:managedObjectContext
												sectionNameKeyPath:nil 
														 cacheName:@"RoskildeArtists"];
	[frc setDelegate:self];
	[self setFetchedResultsController:frc];
	[frc release], frc = nil;
	
	[fetchRequest release], fetchRequest = nil;
	[sortDescriptor release], sortDescriptor = nil;
	[sortDescriptors release], sortDescriptors = nil;
	
	return fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller  {
	[self clearTimeLine];
}

- (void)controller:(NSFetchedResultsController*)controller 
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo 
           atIndex:(NSUInteger)sectionIndex 
     forChangeType:(NSFetchedResultsChangeType)type {
	
}

- (void)controller:(NSFetchedResultsController*)controller 
   didChangeObject:(id)anObject 
       atIndexPath:(NSIndexPath*)indexPath 
     forChangeType:(NSFetchedResultsChangeType)type 
      newIndexPath:(NSIndexPath*)newIndexPath {
	switch(type) {
		case NSFetchedResultsChangeUpdate:
			[self drawTimeLine];
			break;
	}  
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller {
	
} 

@end


@implementation ConcertButton

@synthesize music;

@end
