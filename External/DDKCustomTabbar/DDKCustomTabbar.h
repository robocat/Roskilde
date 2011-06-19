//
//  DDKCustomTabbar.h
//  VAOMoscowGuide
//
//  Created by Dmitry Sukhorukov on 10/13/10.
//  Copyright 2010 AR Door. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDKCustomTabButton;
@class DDKBorderView;

@protocol DDKTabBarDelegate

-(UIView*) viewForToolBar;
-(BOOL) toolBarWithShadow;
@optional

-(BOOL) resizeViewToFit;
-(BOOL) maximizeTabContent;
@end

@interface DDKCustomTabbar : UIViewController <UINavigationControllerDelegate> 
{
@private
	NSDictionary* viewControllers;
	NSArray* tabButtons;
	
	DDKBorderView* leftBorderView;
	DDKBorderView* rightBorderView;
	
	CGFloat leftBorderWidth;
	CGFloat rightBorderWidth;
	CGFloat topBorderHeight;
	CGFloat bottomBorderHeight;
	
	NSUInteger selectedIndex;
	
	DDKBorderView* currentToolBarViewBorder;
	UIView* currentToolBarView;
	
	UIInterfaceOrientation autohideOrientation;
}

@property (nonatomic, retain) NSDictionary* viewControllers;
@property (nonatomic, retain) NSArray* tabButtons;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic) UIInterfaceOrientation autohideOrientation;

// manage buttons

-(void) insertTabButton:(DDKCustomTabButton*)btn atIndex:(NSUInteger)positionIndex;
-(void) setViewController:(UIViewController*)controller atIndex:(NSUInteger)idx;

@end
