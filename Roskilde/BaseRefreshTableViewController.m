//
//  BaseTableViewController.m
//  XKamera
//
//  Created by Willi Wu on 20/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseRefreshTableViewController.h"
#import "RKCustomNavigationBar.h"


@implementation BaseRefreshTableViewController

#pragma mark - View lifecycle

- (void)awakeFromNib {
	textPull = [[NSString alloc] initWithString:@"Pull down to refresh..."];
	textRelease = [[NSString alloc] initWithString:@"Release to refresh..."];
	textLoading = [[NSString alloc] initWithString:@"Loading..."];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Custom navbar
	RKCustomNavigationBar *navBar = (RKCustomNavigationBar*)self.navigationController.navigationBar;
	[navBar setBackgroundWith:[UIImage imageNamed:@"navbar.png"]];
}

- (void)setTitle:(NSString *)title
{
	[super setTitle:title];
	
	// this will appear as the title in the navigation bar
	CGRect frame = CGRectMake(0, 0, 320, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	label.shadowOffset = CGSizeMake(0.0, 1.0);
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor blackColor];//[UIColor colorWithRed:0.217 green:0.256 blue:0.500 alpha:1.000];
	self.navigationItem.titleView = label;
	label.text = title;
	[label sizeToFit];
}

@end
