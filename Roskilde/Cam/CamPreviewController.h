//
//  CamPreviewController.h
//  XKamera
//
//  Created by Ulrik Damm on 5/5/11.
//  Copyright 2011 ITU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "RKCustomNavigationBar.h"

@interface CamPreviewController : UIViewController <UITextViewDelegate, UIScrollViewDelegate> {
	NSUInteger selectedIndex;
}

@property (nonatomic, retain) IBOutlet UIView *uploadView;
@property (nonatomic, retain) IBOutlet UIView *previewView;
@property (nonatomic, retain) IBOutlet UILabel *descriptionPlaceholder;
@property (nonatomic, retain) IBOutlet UITextView *description;
@property (nonatomic, retain) IBOutlet UITextField *location;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet RKCustomNavigationBar *navbar;

- (id)initWithImages:(NSArray*)initimages selectedIndex:(NSUInteger)index;

- (IBAction)upload:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)performUpload:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)pageControlValueChanged:(id)sender;

@end
