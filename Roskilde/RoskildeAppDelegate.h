//
//  RoskildeAppDelegate.h
//  Roskilde
//
//  Created by Willi Wu on 19/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTabBarController.h"

@interface RoskildeAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	UIImageView *scheduleIcon;
	UIImageView *artistsIcon;
	UIImageView *picturesIcon;
	UIImageView *robocatIcon;
	
	UIImageView *splashView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BaseTabBarController *tabBarController;

@property (nonatomic, retain) IBOutlet UIImageView *scheduleIcon;
@property (nonatomic, retain) IBOutlet UIImageView *artistsIcon;
@property (nonatomic, retain) IBOutlet UIImageView *picturesIcon;
@property (nonatomic, retain) IBOutlet UIImageView *robocatIcon;

@end
