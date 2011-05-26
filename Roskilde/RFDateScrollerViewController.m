//
//  RFDateScrollerViewController.m
//  Roskilde
//
//  Created by Willi Wu on 18/06/10.
//  Copyright 2010 Robocat. All rights reserved.
//

#import "RFDateScrollerViewController.h"


@implementation RFDateScrollerViewController

@synthesize delegate;
@synthesize currentPageNumber;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	currentPageNumber = 0;
	
	_scrollView.clipsToBounds = NO;
	_scrollView.pagingEnabled = YES;
	_scrollView.showsHorizontalScrollIndicator = NO;
	
	CGFloat contentOffset = 0.0f;
	NSArray *imageFilenames = [NSArray arrayWithObjects:
							   @"june26.png",
							   @"june27.png",
							   @"june28.png",
							   @"june29.png",
							   @"june30.png",
							   @"july1.png",
							   @"july2.png",
							   @"july3.png",
							   nil];
	
	for (NSString *singleImageFilename in imageFilenames) {
		CGRect imageViewFrame = CGRectMake(contentOffset, 0.0f, _scrollView.frame.size.width, _scrollView.frame.size.height);
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
		imageView.image = [UIImage imageNamed:singleImageFilename];
		imageView.contentMode = UIViewContentModeCenter;
		[_scrollView addSubview:imageView];
		[imageView release];
		
		contentOffset += imageView.frame.size.width;
		_scrollView.contentSize = CGSizeMake(contentOffset, _scrollView.frame.size.height);
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_scrollView release];
	
    [super dealloc];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageNumber = page;
	
	if ([delegate respondsToSelector:@selector(dateScrollview:didSwitchToPage:)]) {
		[delegate dateScrollview:self didSwitchToPage:currentPageNumber];
	}
}

- (void)changePage:(NSString *)date {
	int page = 0;
	
	// Scroll view width
	if ([date isEqualToString:@"2011-06-26"]) {
		page = 0;
	}
	else if ([date isEqualToString:@"2011-06-27"]) {
		page = 1;
	}
	else if ([date isEqualToString:@"2011-06-28"]) {
		page = 2;
	}
	else if ([date isEqualToString:@"2011-06-29"]) {
		page = 3;
	}
	else if ([date isEqualToString:@"2011-06-30"]) {
		page = 4;
	}
	else if ([date isEqualToString:@"2011-07-01"]) {
		page = 5;
	}
	else if ([date isEqualToString:@"2011-07-02"]) {
		page = 6;
	}
	else { //2011-07-03
		page = 7;
	}
	
	
	// update the scroll view to the appropriate page
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
}

@end
