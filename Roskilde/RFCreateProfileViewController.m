//
//  RFCreateProfileViewController.m
//  Roskilde
//
//  Created by Willi Wu on 26/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFCreateProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RFLoginViewController.h"


@implementation RFCreateProfileViewController
@synthesize loginButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[loginButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = @"Create Profile";
	
	loginButton.layer.cornerRadius = 8;
}

- (void)viewDidUnload {
	[self setLoginButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) loginButtonPressed:(id)sender {
	RFLoginViewController *controller = [[RFLoginViewController alloc] initWithNibName:@"RFLoginViewController" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
//	if ((cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"])) {
//		<#statements#>
//	}
}

@end
