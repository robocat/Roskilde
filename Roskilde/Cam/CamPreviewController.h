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

@class CamPreviewController;

@protocol CamPreviewDelegate <NSObject>
@optional

- (void)CamPreview:(CamPreviewController*)camPreview didFailUploadingIndex:(int)index;
- (void)CamPreview:(CamPreviewController*)camPreview didSucceedUploadingIndex:(int)index;

@end

@interface CamPreviewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate> {
	NSUInteger selectedIndex;
	NSString *replyTo;
}

@property (nonatomic, retain) IBOutlet UIView *uploadView;
@property (nonatomic, retain) IBOutlet UIView *previewView;
@property (nonatomic, retain) IBOutlet UILabel *descriptionPlaceholder;
@property (nonatomic, retain) IBOutlet UITextView *description;
@property (nonatomic, retain) IBOutlet UITextField *location;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet RKCustomNavigationBar *navbar;
@property (nonatomic, assign) id<CamPreviewDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIButton *locationButton;
@property (nonatomic, retain) NSString *replyTo;


- (id)initWithImages:(NSArray*)initimages selectedIndex:(NSUInteger)index;

- (IBAction)upload:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)performUpload:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)chooseLocation:(id)sender;

@end
