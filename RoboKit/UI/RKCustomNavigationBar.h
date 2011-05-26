//
//  RKCustomNavigationBar.h
//  Robokit
//
//  Created by Willi Wu on 20/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RKCustomNavigationBar : UINavigationBar {
	UIImageView *navigationBarBackgroundImage;
	CGFloat backButtonCapWidth;
	IBOutlet UINavigationController* navigationController;
}

@property (nonatomic, retain) UIImageView *navigationBarBackgroundImage;
@property (nonatomic, retain) IBOutlet UINavigationController* navigationController;

-(void) setBackgroundWith:(UIImage*)backgroundImage;
-(void) clearBackground;
-(UIButton*) backButtonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)capWidth;
-(void) setText:(NSString*)text onBackButton:(UIButton*)backButton;

@end
