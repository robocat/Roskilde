//
//  RFDateScrollerViewController.h
//  Roskilde
//
//  Created by Willi Wu on 18/06/10.
//  Copyright 2010 Robocat. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RFDateScrollerViewControllerDelegate;

@interface RFDateScrollerViewController : UIViewController <UIScrollViewDelegate> {
	id delegate;
	
	UIScrollView	*_scrollView;
	NSUInteger currentPageNumber;
}

@property (nonatomic, assign) id<RFDateScrollerViewControllerDelegate> delegate;
@property (nonatomic, assign) NSUInteger currentPageNumber;
@property (nonatomic, retain) IBOutlet UIScrollView	*_scrollView;

- (void)changePage:(NSString *)date;

@end



@protocol RFDateScrollerViewControllerDelegate <NSObject>
@optional
- (void) dateScrollview:(RFDateScrollerViewController *)scollview didSwitchToPage:(NSUInteger)page;
@end