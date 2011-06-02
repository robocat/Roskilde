//
//  BaseRefreshViewController.m
//  Roskilde
//
//  Created by Willi Wu on 01/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseRefreshViewController.h"
#import "RKCustomNavigationBar.h"


@implementation BaseRefreshViewController

@synthesize tableView=_tableView;

#pragma mark - View lifecycle

/*
 * Creates a table view and pull-to-refresh subview.
 */
- (void)loadView {
    
    [super loadView];
	
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
	self.tableView.backgroundColor = [UIColor colorWithRed:0.079 green:0.079 blue:0.079 alpha:1.000];
    self.tableView.frame = CGRectMake(0, 0, 320, 480);
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _pullToRefreshView = [[PullToRefreshView alloc] initWithTableView:self.tableView delegate:self];
	
    [self.tableView addSubview:_pullToRefreshView];
    [self.view addSubview:_tableView];
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

- (void)setWhiteTitle:(NSString *)title
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
	label.textColor = [UIColor whiteColor];//[UIColor colorWithRed:0.217 green:0.256 blue:0.500 alpha:1.000];
	self.navigationItem.titleView = label;
	label.text = title;
	[label sizeToFit];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_pullToRefreshView scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {    
    [_pullToRefreshView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_pullToRefreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark - PullToRefreshAppDelegate Methods

- (void)refreshRequestedForTableView:(UITableView *)tableView {
}

@end
