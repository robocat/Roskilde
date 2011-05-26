//
//  CamViewController.m
//  XKamera
//
//  Created by Ulrik Damm on 5/5/11.
//  Copyright 2011 ITU. All rights reserved.
//

#import "CamViewController.h"
#import "CamDevice.h"
#import "CamPreviewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Resize.h"

#define BackCam YES
#define FrontCam NO

#define OFF NO
#define ON YES

@interface CamViewController ()

- (void)takePhoto;
- (void)didRotateToInterfaceOrientation:(UIDeviceOrientation)orientation;

@property (nonatomic, retain) CamDevice *camdevice;
@property (nonatomic, retain) UILabel *flashLabel;

@end


@implementation CamViewController

@synthesize timerView;
@synthesize camview;
@synthesize camdevice;
@synthesize slideView;
@synthesize thumbnailView;
@synthesize takePhotoButton;
@synthesize timerIcon;
@synthesize libraryButton;
@synthesize timerButton;
@synthesize flipButton;
@synthesize flashButton;
@synthesize flashLabel;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.camdevice = nil;
	
	camOrientation = FrontCam;
	
	timer = OFF;
	timerView.hidden = YES;
	timerIcon.hidden = YES;
	
	timerView.layer.cornerRadius = 10;
	
	[self.thumbnailView setThumbnailDelegate:self];
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	
	[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *lol) {
		self.view.userInteractionEnabled = YES;
	}];
	
	[[NSNotificationCenter defaultCenter] addObserverForName:@"UIDeviceOrientationDidChangeNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *lol) {
		[self didRotateToInterfaceOrientation:[UIDevice currentDevice].orientation];
	}];
	
	self.flashLabel = [[[UILabel alloc] initWithFrame:CGRectMake(23, 8, 35, 15)] autorelease];
	self.flashLabel.font = [UIFont italicSystemFontOfSize:13];
	self.flashLabel.backgroundColor = [UIColor clearColor];
	self.flashLabel.text = @"auto";
	self.flashLabel.textAlignment = UITextAlignmentCenter;
	[self.flashButton addSubview:self.flashLabel];
	
	[self.flashButton setHidden:YES];
}


- (IBAction)changeFlash:(id)sender {
	if (self.camdevice.flash == CamDeviceFlashOn) {
		self.camdevice.flash = CamDeviceFlashOff;
		self.flashLabel.text = @"off";
	} else if (self.camdevice.flash == CamDeviceFlashOff) {
		self.camdevice.flash = CamDeviceFlashAuto;
		self.flashLabel.text = @"auto";
	} else {
		self.camdevice.flash = CamDeviceFlashOn;
		self.flashLabel.text = @"on";
	}
}


- (void)didRotateToInterfaceOrientation:(UIDeviceOrientation)orientation {
	[UIView animateWithDuration:0.3 animations:^(void) {
		CGFloat rotation = (orientation == UIInterfaceOrientationPortrait? 0:
							orientation == UIInterfaceOrientationPortraitUpsideDown? M_PI:
							orientation == UIInterfaceOrientationLandscapeLeft? -M_PI_2:
							orientation == UIInterfaceOrientationLandscapeRight? M_PI_2: 0);
		self.libraryButton.transform = CGAffineTransformMakeRotation(rotation);
		self.timerButton.transform = CGAffineTransformMakeRotation(rotation);
		self.flipButton.transform = CGAffineTransformMakeRotation(rotation);
		self.flashButton.transform = CGAffineTransformMakeRotation(rotation);
		
		if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
			self.flipButton.frame = CGRectMake(271, 20, 31, 60);
			self.flashButton.frame = CGRectMake(20, 20, 31, 60);
		} else {
			self.flipButton.frame = CGRectMake(240, 20, 60, 31);
			self.flashButton.frame = CGRectMake(20, 20, 60, 31);
		}
	}];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (!self.camdevice) {
		dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
			self.camdevice = [[[CamDevice alloc] initWithCameraType:(camOrientation == FrontCam? CamDeviceTypeFront: CamDeviceTypeBack)] autorelease];
			self.camview.flipped = (camOrientation == FrontCam? YES: NO);
			[self.camdevice setSampleBufferDelegate:self.camview];
			
			dispatch_async(dispatch_get_main_queue(), ^(void) {
				[UIView animateWithDuration:0.3 animations:^(void) {
					self.slideView.frame = CGRectMake(0,
													  -self.slideView.frame.size.height,
													  self.slideView.frame.size.width,
													  self.slideView.frame.size.height);
				}];
			});
		});
		
		AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"tick" ofType:@"aiff"]], &tickSound);
	}
}


- (void)viewWillDisappear:(BOOL)animated {
	self.camdevice = nil;
}

- (IBAction)takePhoto:(id)sender {
	if (timer) {
		self.view.userInteractionEnabled = NO;
		
		timerView.text = @"3";
		timerIcon.hidden = YES;
		AudioServicesPlaySystemSound(tickSound);
		
		dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
			sleep(1);
			dispatch_async(dispatch_get_main_queue(), ^(void) {
				timerView.text = @"2";
				AudioServicesPlaySystemSound(tickSound);
			});
			
			sleep(1);
			dispatch_async(dispatch_get_main_queue(), ^(void) {
				timerView.text = @"1";
				AudioServicesPlaySystemSound(tickSound);
			});
			
			sleep(1);
			dispatch_async(dispatch_get_main_queue(), ^(void) {
				timerView.text = @"";
				timerIcon.hidden = NO;
				[self takePhoto];
				
				self.view.userInteractionEnabled = YES;
			});
		});
	} else {
		[self takePhoto];
	}
}


- (void)takePhoto {
	[takePhotoButton setImage:[UIImage imageNamed:@"camera_pressed.png"] forState:UIControlStateNormal];
	takePhotoButton.userInteractionEnabled = NO;
	
	UIView *flash = nil;
	
	if (camOrientation == FrontCam) {
		UIView *flash = [[UIView alloc] initWithFrame:self.camview.bounds];
		flash.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
		flash.userInteractionEnabled = NO;
		[self.camview addSubview:flash];
		
		[UIView animateWithDuration:0.2 animations:^{
			flash.alpha = 0;
		} completion:^(BOOL finished) {
			[flash removeFromSuperview];
		}];
	}
	
	[self.camdevice takePhotoWithCompletionHandler:^(UIImage *image) {
		[flash removeFromSuperview];
		
		[self.thumbnailView addThumbnail:image];
		
		[takePhotoButton setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
		takePhotoButton.userInteractionEnabled = YES;
	}];
	
	[flash release];
}


- (IBAction)flipCamera:(id)sender {
	if (camOrientation == FrontCam) {
		self.camdevice = [[[CamDevice alloc] initWithCameraType:CamDeviceTypeBack] autorelease];
		self.camview.flipped = NO;
		self.camdevice.flash = CamDeviceFlashAuto;
		self.flashLabel.text = @"auto";
		[self.camdevice setSampleBufferDelegate:self.camview];
		
		[self.flashButton setHidden:NO];
	} else {
		self.camdevice = [[[CamDevice alloc] initWithCameraType:CamDeviceTypeFront] autorelease];
		self.camview.flipped = YES;
		[self.camdevice setSampleBufferDelegate:self.camview];
		
		[self.flashButton setHidden:YES];
	}
	
	camOrientation = !camOrientation;
}


- (IBAction)close:(id)sender {
	[UIView animateWithDuration:0.2 animations:^(void) {
		self.slideView.frame = CGRectMake(0,
										  0,
										  self.slideView.frame.size.width,
										  self.slideView.frame.size.height);
	} completion:^(BOOL finished) {
		[self.camview removeFromSuperview];
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
		[self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
		[self dismissModalViewControllerAnimated:YES];
	}];
}


- (void)ThumbnailViewThumbnailPressed:(NSUInteger)index {
	CamPreviewController *previewController = [[CamPreviewController alloc] initWithImages:thumbnailView.allThumbnails selectedIndex:index];
	[self.navigationController pushViewController:previewController animated:YES];
	[previewController release];
}


- (void)viewDidUnload {
	[self setTakePhotoButton:nil];
	[self setTimerView:nil];
	[self setTimerIcon:nil];
	[self setLibraryButton:nil];
	[self setTimerButton:nil];
	[self setFlipButton:nil];
	[super viewDidUnload];
	
	self.camview = nil;
	self.camdevice = nil;
	self.slideView = nil;
	self.thumbnailView = nil;
}

- (IBAction)library:(id)sender {
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:imagePickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *image = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
	
	if (image.size.width > image.size.height) {
		if (image.size.width > 640*4 && image.size.height > 480*4) {
			image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(640*4, 480*4) interpolationQuality:kCGInterpolationHigh];
		}
	} else {
		if (image.size.width > 640*4 && image.size.height > 480*4) {
			image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(480*4, 640*4) interpolationQuality:kCGInterpolationHigh];
		}
	}
	
	CamPreviewController *previewController = [[CamPreviewController alloc] initWithImages:[NSArray arrayWithObject:image] selectedIndex:0];
	[self.navigationController pushViewController:previewController animated:YES];
	[previewController release];
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)timer:(id)sender {
	timer = !timer;
	timerButton.selected = timer;
	
	if (timer) {
		timerView.hidden = NO;
		timerIcon.hidden = NO;
	} else {
		timerView.hidden = YES;
		timerIcon.hidden = YES;
	}
}

- (void)dealloc {
	AudioServicesDisposeSystemSoundID(tickSound);
	
	[takePhotoButton release];
	[timerView release];
	[timerIcon release];
	[libraryButton release];
	[timerButton release];
	[flipButton release];
	[super dealloc];
}
@end
