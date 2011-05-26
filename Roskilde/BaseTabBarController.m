//
//  BaseTabBarController.m
//  Roskilde
//
//  Created by Willi Wu on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseTabBarController.h"
#import "CamViewController.h"


@implementation BaseTabBarController


// Create a view controller and setup it's tab bar item with a title and image
-(UIViewController*) viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image
{
	UIViewController* viewController = [[[UIViewController alloc] init] autorelease];
	viewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:title image:image tag:0] autorelease];
	return viewController;
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(127.0, 2.0, buttonImage.size.width, buttonImage.size.height);
	[button setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
	[button addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
//	CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
//	if (heightDifference < 0)
//		button.center = self.tabBar.center;
//	else
//	{
//		CGPoint center = self.tabBar.center;
//		center.y = center.y - heightDifference/2.0;
//		button.center = center;
//	}
	
	[self.tabBar addSubview:button];
}


- (void)cameraButtonPressed:(id)sender
{
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		CamViewController *camViewController = [[CamViewController alloc] initWithNibName:@"CamViewController" bundle:nil];
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:camViewController];
		
		[navigationController setNavigationBarHidden:YES];
		
		[self presentModalViewController:navigationController animated:NO];
		[navigationController release];
		[camViewController release];
	}
}


#pragma mark -
#pragma mark OverlayViewControllerDelegate

// as a delegate we are being told a picture was taken
- (void)didTakePicture:(UIImage *)picture
{
	
}

// as a delegate we are told to finished with the camera
- (void)didFinishWithCamera
{
	[self dismissModalViewControllerAnimated:NO];
    
}


@end
