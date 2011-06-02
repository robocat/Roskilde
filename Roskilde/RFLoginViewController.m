//
//  RFLoginViewController.m
//  Roskilde
//
//  Created by Willi Wu on 26/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFLoginViewController.h"

@interface RFLoginViewController ()

@property (nonatomic, retain) UITextField *usernameTextField;
@property (nonatomic, retain) UITextField *passwordTextField;

@end


@implementation RFLoginViewController

@synthesize usernameTextField;
@synthesize passwordTextField;

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
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Log In";
	
	[[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *lol) {
		[UIView animateWithDuration:.3 animations:^(void) {
			self.view.frame = CGRectOffset(self.view.frame, 0, 220);
		}];
	}];
	
	[[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *lol) {
		[UIView animateWithDuration:.3 animations:^(void) {
			self.view.frame = CGRectOffset(self.view.frame, 0, -220);
		}];
	}];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	if ((cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"]) == nil) {
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
	else {
		cell.textLabel.text = @"Password";
		self.passwordTextField = (UITextField*)[cell viewWithTag:1];
		input.secureTextEntry = YES;
		input.returnKeyType = UIReturnKeyNext;
	}

	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		[self.usernameTextField becomeFirstResponder];
	} else if (indexPath.row == 1) {
		[self.passwordTextField becomeFirstResponder];
	}
}


-(void)textFieldDidEndEditing:(UITextField *)textField  {
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	
	if (textField.tag == 0)
	{
		
		NSLog(@"Username: %@", textField.text);
	}
	else
	{
		NSLog(@"Password: %@", textField.text);
	}
	
	return NO;
}


@end
