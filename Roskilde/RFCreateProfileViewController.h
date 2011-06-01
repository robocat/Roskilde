//
//  RFCreateProfileViewController.h
//  Roskilde
//
//  Created by Willi Wu on 26/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RFCreateProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
	UIButton *loginButton;
}

@property (nonatomic, retain) IBOutlet UIButton *loginButton;

- (IBAction) loginButtonPressed:(id)sender;

@end
