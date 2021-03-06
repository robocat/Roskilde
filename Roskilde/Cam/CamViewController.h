//
//  CamViewController.h
//  XKamera
//
//  Created by Ulrik Damm on 5/5/11.
//  Copyright 2011 ITU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CamView.h"
#import "CamThumbnailView.h"
#import <AudioToolbox/AudioServices.h>
#import "CamPreviewController.h"

@interface CamViewController : UIViewController <CamThumbnailViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CamPreviewDelegate> {
	BOOL camOrientation;
	BOOL timer;
	SystemSoundID tickSound;
	UIImageView *timerIcon;
	UIButton *flipButton;
	
	NSString * replyTo;
}

@property (nonatomic, retain) IBOutlet UILabel *timerView;
@property (nonatomic, retain) IBOutlet CamView *camview;
@property (nonatomic, retain) IBOutlet UIView *slideView;
@property (nonatomic, retain) IBOutlet CamThumbnailView *thumbnailView;
@property (nonatomic, retain) IBOutlet UIButton *takePhotoButton;
@property (nonatomic, retain) IBOutlet UIImageView *timerIcon;
@property (nonatomic, retain) IBOutlet UIButton *libraryButton;
@property (nonatomic, retain) IBOutlet UIButton *timerButton;
@property (nonatomic, retain) IBOutlet UIButton *flipButton;
@property (nonatomic, retain) IBOutlet UIButton *flashButton;
@property (nonatomic, retain) NSString *replyTo;


- (IBAction)changeFlash:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)flipCamera:(id)sender;
- (IBAction)close:(id)sender;
- (IBAction)library:(id)sender;
- (IBAction)timerUp:(id)sender;
- (IBAction)timerDown:(id)sender;

@end
