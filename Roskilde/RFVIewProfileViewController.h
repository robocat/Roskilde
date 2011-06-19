//
//  RFVIewProfileViewController.h
//  Roskilde
//
//  Created by Willi Wu on 19/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLImageView;

@interface RFVIewProfileViewController : UIViewController {
    
	UILabel *profileLabel;
	UIButton *profileButton;
	UILabel *imagesCountLabel;
	UILabel *nameLabel;
	FLImageView *imageView;
}

@property (nonatomic, retain) IBOutlet FLImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *profileLabel;
@property (nonatomic, retain) IBOutlet UIButton *profileButton;
@property (nonatomic, retain) IBOutlet UILabel *imagesCountLabel;

- (IBAction)profileButtonPressed:(id)sender;

@end
