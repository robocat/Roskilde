//
//  RFCreateProfileViewController.h
//  Roskilde
//
//  Created by Willi Wu on 26/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RFCreateProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    
	UIButton *loginButton;
	UITableView *tableView;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;

- (IBAction) loginButtonPressed:(id)sender;

@end
