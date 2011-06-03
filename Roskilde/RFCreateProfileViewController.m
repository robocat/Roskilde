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
#import "ASIFormDataRequest.h"

@interface RFCreateProfileViewController ()

@property (nonatomic, retain) UITextField *usernameTextField;
@property (nonatomic, retain) UITextField *passwordTextField;
@property (nonatomic, retain) UITextField *emailTextField;

-(void)joinButtonPressed:(id)sender;

@end


@implementation RFCreateProfileViewController

@synthesize tableView;
@synthesize loginButton;
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize emailTextField;
@synthesize username;
@synthesize password;
@synthesize email;


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
	
	self.username = nil;
    self.password = nil;
    self.email = nil;
	
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
		input.returnKeyType = UIReturnKeyJoin;
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


- (void)checkInputs {
	if (self.username && self.password) {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Join" style:UIBarButtonItemStylePlain target:self action:nil];
	}
	else {
		self.navigationItem.rightBarButtonItem = nil;
	}
}


-(void)textFieldDidEndEditing:(UITextField *)textField  {
	if (textField.tag == 0)
	{
		self.username = textField.text;
	}
	else if (textField.tag == 1)
	{
		self.password = textField.text;
	}
	else
	{
		self.email = textField.text;
	}
	
	[self checkInputs];
}

- (BOOL)isValidForRegex:(NSString *)regEx string:(NSString *)string {
	NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
	return [regExPredicate evaluateWithObject:string];
}

- (BOOL)isValidated {
	
	NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
	
	NSString *usernameRegEx = @"[a-zA-Z0-9_-]{3,}";
		
	if ([self isValidForRegex:usernameRegEx string:self.username]
		&& [self isValidForRegex:emailRegEx string:self.email]) {
		return YES;
	}
	
	[[[[UIAlertView alloc] initWithTitle:@"Profile info missing" message:@"Please correct the info and try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
	
	return NO;
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
		[self joinButtonPressed:nil];
		NSLog(@"Email: %@", textField.text);
	}
	
	return NO;
}


-(void)joinButtonPressed:(id)sender
{
	if (self.username && self.password && self.email && [self isValidated]) {
		NSString *urlString = [NSString stringWithFormat:@"%@/user/auth/%@?password=%@&email=%@", kXdkAPIBaseUrl, self.username, self.password, self.email];
		NSURL *url = [NSURL URLWithString:urlString];
		
		__block ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:url];
		formRequest.requestMethod = @"POST";
				
		[formRequest setCompletionBlock:^{
			// Use when fetching text data
//			NSString *responseString = [formRequest responseString];
			int statusCode = [formRequest responseStatusCode];
//			LOG_EXPR(statusCode);
//			LOG_EXPR(responseString);
			
			// Save profile
			
			if (statusCode == 200 || statusCode == 201) {
				[RFGlobal saveUsername:self.username password:self.password];
				[[NSNotificationCenter defaultCenter] postNotificationName:kUserLoggedIn object:nil];
				[self.parentViewController dismissModalViewControllerAnimated:YES];
			}
			else {
				[[[[UIAlertView alloc] initWithTitle:@"Create User Failed" message:@"Please correct the info and try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
			}
		}];
		
		[formRequest setFailedBlock:^{
			NSError *error = [formRequest error];
			NSLog(@"error: %@", error);
			
			// Show alert
			[[[[UIAlertView alloc] initWithTitle:@"Create User Failed" message:@"Please correct the info and try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
		}];
		
		[formRequest startAsynchronous];
	}
}


@end
