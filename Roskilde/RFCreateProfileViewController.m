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

@synthesize tableView;
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
	[tableView release];
	[tableView release];
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
	[tableView release];
	tableView = nil;
	[self setTableView:nil];
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


- (NSInteger)tableView:(UITableView *)tableView_ numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	if ((cell = [self.tableView dequeueReusableCellWithIdentifier:@"TableCell"]) == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"] autorelease];		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	UITextField *input = [[[UITextField alloc] initWithFrame:CGRectMake(125, 10, cell.frame.size.width-135, cell.frame.size.height-20)] autorelease];
	input.delegate = self;
	input.tag = indexPath.row;
	input.clearButtonMode = UITextFieldViewModeWhileEditing;
	input.enablesReturnKeyAutomatically = YES;
	input.autocorrectionType = UITextAutocorrectionTypeNo;
	input.autocapitalizationType = UITextAutocapitalizationTypeNone;
	[cell addSubview:input];
	
	if (indexPath.row == 0) {
		cell.textLabel.text = @"Username";
		self.usernameTextField = (UITextField*)[cell viewWithTag:0];
		input.returnKeyType = UIReturnKeyNext;
	}
	else if (indexPath.row == 1) {
		cell.textLabel.text = @"Password";
		self.passwordTextField = (UITextField*)[cell viewWithTag:1];
		input.secureTextEntry = YES;
		input.returnKeyType = UIReturnKeyNext;
	}
	else {
		cell.textLabel.text = @"Email";
		self.emailTextField = (UITextField*)[cell viewWithTag:2];
		input.keyboardType = UIKeyboardTypeEmailAddress;
		input.returnKeyType = UIReturnKeyGo;
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

-(void)textFieldDidEndEditing:(UITextField *)textField  {
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	
	if (textField.tag == 0)
	{
		UITableViewCell* cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
		[[[cell subviews] objectAtIndex:0] becomeFirstResponder];
		
		NSLog(@"Username: %@", textField.text);
	}
	else if (textField.tag == 1)
	{
		UITableViewCell* cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
		[[[cell subviews] objectAtIndex:0] becomeFirstResponder];
		
		NSLog(@"Password: %@", textField.text);
	}
	else
	{
		NSLog(@"Email: %@", textField.text);
	}
	
	return NO;
}


@end
