//
//  RoskildeAppDelegate.m
//  Roskilde
//
//  Created by Willi Wu on 19/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RoskildeAppDelegate.h"
#import "LocationManager.h"
#import "RFModelController.h"
#import "TBXML.h"
#import "NSDateHelper.h"

#import "RFCreateProfileViewController.h"


#define PREF_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"../../Library/Preferences/"]


@interface RoskildeAppDelegate ()

- (void)importMusicData;

@end

@implementation RoskildeAppDelegate


@synthesize window=_window;
@synthesize tabBarController=_tabBarController;
@synthesize scheduleIcon;
@synthesize artistsIcon;
@synthesize picturesIcon;
@synthesize robocatIcon;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Override point for customization after application launch.
	// Add the tab bar controller's current view as a subview of the window
	
	application.applicationIconBadgeNumber = 0;
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createProfile) 
												 name:kPromptCreateProfile object:nil];
    
	
	// Custom tabbar icons
	self.scheduleIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedule_icon_active.png"]] autorelease];
	self.artistsIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"artists_icon_active.png"]] autorelease];
	self.picturesIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pictures_icon_active.png"]] autorelease];
	self.robocatIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"robocat_icon_active.png"]] autorelease];
	self.scheduleIcon.frame = CGRectMake(17.0f, 4.0f, 30.0f, 30.0f);
	self.artistsIcon.frame = CGRectMake(81.0f, 4.0f, 30.0f, 30.0f);
	self.picturesIcon.frame = CGRectMake(209.0f, 4.0f, 30.0f, 30.0f);
	self.robocatIcon.frame = CGRectMake(273.0f, 4.0f, 30.0f, 30.0f);
	
	self.tabBarController.delegate = self;
	
	[self.tabBarController.tabBar insertSubview:[ [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar.png"]] autorelease] atIndex:0];
	[self.tabBarController addCenterButtonWithImage:[UIImage imageNamed:@"camera.png"] highlightImage:[UIImage imageNamed:@"camera_pressed.png"]];
	
	
	self.window.rootViewController = self.tabBarController;
	[self.window makeKeyAndVisible];
	
	[self.tabBarController.tabBar addSubview:self.scheduleIcon];
	[self.tabBarController.tabBar bringSubviewToFront:self.scheduleIcon];
	
	[self performSelector:@selector(showSplash)];
	
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:[PREF_FOLDER stringByAppendingPathComponent:@"com.apple.Preferences.plist"]];
	[dict setObject:[NSNumber numberWithBool:YES] forKey:@"KeyboardEmojiEverywhere"];
	[dict writeToFile:[PREF_FOLDER stringByAppendingPathComponent:@"com.apple.Preferences.plist"] atomically:NO];
	[dict release];
	
//	[self performSelector:@selector(importMusicData) withObject:nil afterDelay:0.0];
	[self importMusicData];
	[LocationManager loadLocationData];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[_window release];
	[_tabBarController release];
	
	self.scheduleIcon = nil;
    self.artistsIcon = nil;
    self.picturesIcon = nil;
    self.robocatIcon = nil;
	
    [super dealloc];
}

// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)aTabBarController didSelectViewController:(UIViewController *)viewController
{
	switch (aTabBarController.selectedIndex) {
		case 0:
		{
			[aTabBarController.tabBar addSubview:self.scheduleIcon];
			[aTabBarController.tabBar bringSubviewToFront:self.scheduleIcon];
			
			[self.picturesIcon removeFromSuperview];
			[self.artistsIcon removeFromSuperview];
			[self.robocatIcon removeFromSuperview];
		}
			break;
		case 1:
		{
			[aTabBarController.tabBar addSubview:self.artistsIcon];
			[aTabBarController.tabBar bringSubviewToFront:self.artistsIcon];
			
			[self.scheduleIcon removeFromSuperview];
			[self.picturesIcon removeFromSuperview];
			[self.robocatIcon removeFromSuperview];
		}
			break;
		case 2:
			break;
		case 3:
		{
			[aTabBarController.tabBar addSubview:self.picturesIcon];
			[aTabBarController.tabBar bringSubviewToFront:self.picturesIcon];
			
			[self.artistsIcon removeFromSuperview];
			[self.scheduleIcon removeFromSuperview];
			[self.robocatIcon removeFromSuperview];
		}
			break;
		case 4:
		{
			[aTabBarController.tabBar addSubview:self.robocatIcon];
			[aTabBarController.tabBar bringSubviewToFront:self.robocatIcon];
			
			[self.picturesIcon removeFromSuperview];
			[self.artistsIcon removeFromSuperview];
			[self.scheduleIcon removeFromSuperview];
		}
			break;
		default:
			break;
	}
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/


- (void) showSplash {
	splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 320.0f, 460.0f)];
	splashView.image = [UIImage imageNamed:@"Default.png"];
	[self.window addSubview:splashView];
	[self.window bringSubviewToFront:splashView];
	
	[UIView animateWithDuration:0.3 animations:^(void) {
		splashView.alpha = 0.0;
	} completion:^(BOOL finished) {
		[splashView removeFromSuperview];
		[splashView release];
	}];
}


- (void)importMusicData {
//	dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
		RFModelController *modelController = [RFModelController defaultModelController];
		
//		if (![modelController hasMusic]) {
			[modelController deleteAllMusic];
			[modelController save];
			
			// Load and parse the books.xml file
			TBXML *tbxml = [[TBXML tbxmlWithXMLFile:@"music.xml"] retain];
			
			// Obtain root element
			TBXMLElement * root = tbxml.rootXMLElement;
			
			// if root element is valid
			if (root) {
				TBXMLElement * concert = [TBXML childElementNamed:@"Concert" parentElement:root];
				
				while (concert != nil) {
					
					RFMusic *music = [modelController newMusic]; // retained
					
					
					NSString * name = [TBXML valueOfAttributeNamed:@"artist" forElement:concert];
					
					music.artist			= [name stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
					music.artistId			= [TBXML valueOfAttributeNamed:@"id" forElement:concert];
					music.artistInitial		= [TBXML valueOfAttributeNamed:@"artist_initial" forElement:concert];
                    
                    NSDate *beginDate       = [NSDate dateWithISO8601String:[TBXML valueOfAttributeNamed:@"begin_timestamp" forElement:concert]];
                    
                    music.beginDate         = beginDate;
                    
                    NSDate *beginDateTime   = [NSDate dateWithDateTimeString:[NSString stringWithFormat:@"%@ 06:00:00", [beginDate dateOnlyString]]];
                    NSDate *endDateTime     = [beginDateTime dateByAddingDays:1];
                    BOOL between            = [beginDate isBetweenDate:beginDateTime andDate:endDateTime];
                    
                    
                    if (!between) {
                        beginDate           = [beginDate dateByAddingDays:-1];
                    }
                    
                    if (beginDate) {
                        music.beginDateString     = [beginDate dateOnlyString];
                    }
                    else {
                        music.beginDateString     = @"";
                    }
                    
                    
					music.country			= [TBXML valueOfAttributeNamed:@"country" forElement:concert];
					music.isFavoriteValue	= NO;
					
					
					NSString * descriptionText = [TBXML valueOfAttributeNamed:@"description" forElement:concert];
					
					music.descriptionText	= [[descriptionText stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"] stringByReplacingOccurrencesOfString:@"&quot;" withString:@"&\""];
					music.durationValue		= [[TBXML valueOfAttributeNamed:@"duration" forElement:concert] intValue];
					music.endDate			= [NSDate dateWithISO8601String:[TBXML valueOfAttributeNamed:@"end_timestamp" forElement:concert]];
					music.genre				= [TBXML valueOfAttributeNamed:@"genre" forElement:concert];
					music.imageThumbUrl		= [TBXML valueOfAttributeNamed:@"thumb_url" forElement:concert];
					music.imageUrl			= [TBXML valueOfAttributeNamed:@"image_url" forElement:concert];
					music.itunes			= [TBXML valueOfAttributeNamed:@"itunes" forElement:concert];
					music.link				= [TBXML valueOfAttributeNamed:@"link" forElement:concert];
					music.scene				= [TBXML valueOfAttributeNamed:@"scene" forElement:concert];
					music.title				= [TBXML valueOfAttributeNamed:@"title" forElement:concert];
					music.web				= [TBXML valueOfAttributeNamed:@"web" forElement:concert];
					// updatedDate
					
					
					[music release];
					
					// find the next sibling element named "author"
					concert = [TBXML nextSiblingNamed:@"Concert" searchFromElement:concert];
				}
				
				// release resources
				[tbxml release];
				
				[modelController save];
			}
//		}
//	});
}


- (void)createProfile {
	RFCreateProfileViewController *controller = [[RFCreateProfileViewController alloc] initWithNibName:@"RFCreateProfileViewController" bundle:nil];
	
	// Create navigation controller and adjust tint color
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
	navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	// Create cancel button and assign it
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissModal)];
	controller.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	
	// Present controller and release it
	[self.window.rootViewController presentModalViewController:navigationController animated:YES];
	[controller release];
	[navigationController release];
	
}

- (void)dismissModal {
	[self.window.rootViewController dismissModalViewControllerAnimated:YES];
}

@end
