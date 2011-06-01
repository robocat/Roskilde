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

@interface RFCreateProfileViewController ()

@property (nonatomic, retain) UITextField *usernameTextField;
@property (nonatomic, retain) UITextField *passwordTextField;
@property (nonatomic, retain) UITextField *emailTextField;

@end


@implementation RFCreateProfileViewController

@synthesize loginButton;
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize emailTextField;


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
	
	[[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *lol) {
		[UIView animateWithDuration:.3 animations:^(void) {
			self.view.frame = CGRectOffset(self.view.frame, 0, 150);
		}];
	}];
	
	[[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *lol) {
		[UIView animateWithDuration:.3 animations:^(void) {
			self.view.frame = CGRectOffset(self.view.frame, 0, -150);
		}];
	}];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:nil];
}


- (void)viewDidDisappear:(BOOL)animated {
	[self.usernameTextField resignFirstResponder];
	[self.passwordTextField resignFirstResponder];
	[self.emailTextField resignFirstResponder];
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
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	if ((cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"]) == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"] autorelease];
		
		UITextField *input = [[[UITextField alloc] initWithFrame:CGRectMake(125, 10, cell.frame.size.width-135, cell.frame.size.height-20)] autorelease];
		input.tag = 123;
		[cell addSubview:input];
		
		if (indexPath.row == 1) {
			input.secureTextEntry = YES;
		} else if (indexPath.row == 2) {
			input.keyboardType = UIKeyboardTypeEmailAddress;
		}
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	if (indexPath.row == 0) {
		cell.textLabel.text = @"Username";
		self.usernameTextField = (UITextField*)[cell viewWithTag:123];
	} else if (indexPath.row == 1) {
		cell.textLabel.text = @"Password";
		self.passwordTextField = (UITextField*)[cell viewWithTag:123];
	} else {
		cell.textLabel.text = @"Email";
		self.emailTextField = (UITextField*)[cell viewWithTag:123];
	}
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		[self.usernameTextField becomeFirstResponder];
	} else if (indexPath.row == 1) {
		[self.passwordTextField becomeFirstResponder];
	} else {
		[self.emailTextField becomeFirstResponder];
	}
}

@end
