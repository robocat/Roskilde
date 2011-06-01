//
//  CamViewController.m
//  Cam
//
//  Created by Ulrik Damm on 28/4/11.
//  Copyright 2011 ITU. All rights reserved.
//

#import "CamDevice.h"
#import <CoreVideo/CoreVideo.h>
#import <AVFoundation/AVFoundation.h>

@interface CamDevice ()

@property (nonatomic, retain) AVCaptureDevice *captureDevice;
@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (nonatomic, retain) AVCaptureDeviceInput *captureDeviceInput;
@property (nonatomic, retain) AVCaptureVideoDataOutput *captureVideoDataOutput;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, retain) AVCaptureStillImageOutput *captureStillImageOutput;

@end


@implementation CamDevice

@synthesize captureDevice;
@synthesize captureSession;
@synthesize captureDeviceInput;
@synthesize captureVideoDataOutput;
@synthesize captureVideoPreviewLayer;
@synthesize captureStillImageOutput;
@synthesize flash;


- (void)dealloc {
	[self.captureSession stopRunning];
	
	captureDevice = nil;
	captureSession = nil;
	captureDeviceInput = nil;
	captureVideoDataOutput = nil;
	captureVideoPreviewLayer = nil;
	captureStillImageOutput = nil;
	
	[super dealloc];
}


- (id)initWithCameraType:(CamDeviceType)type {
	if ((self = [super init]) == nil) {
		return nil;
	}
	
	for (AVCaptureDevice *device in [AVCaptureDevice devices]) {
		if ([device position] == (type == CamDeviceTypeFront? AVCaptureDevicePositionFront: AVCaptureDevicePositionBack)) {
			self.captureDevice = device;
			break;
		}
	}
	
	if (!self.captureDevice) {
		[NSException raise:@"SomethingWentWrongException" format:@"Could not find any capture device"];
	}
	
	self.captureSession = [[[AVCaptureSession alloc] init] autorelease];
	
	NSError *error = nil;
	self.captureDeviceInput = [[[AVCaptureDeviceInput alloc] initWithDevice:self.captureDevice error:&error] autorelease];
	
	if (error) [NSException raise:@"SomethingWentWrongException" format:@"Could not initiate capture device input"];
	
	if ([self.captureSession canAddInput:self.captureDeviceInput]) {
		[self.captureSession addInput:self.captureDeviceInput];
	} else {
		[NSException raise:@"SomethingWentWrongException" format:@"Could not could not add capture device as capture session input"];
	}
	
	
	AVCaptureVideoPreviewLayer *videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
	
	if ([videoPreviewLayer isOrientationSupported]) {
		[videoPreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
	}
	
	[videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	
	
	self.captureVideoPreviewLayer = [videoPreviewLayer autorelease];
	
	AVCaptureVideoDataOutput *dataOutput = [[AVCaptureVideoDataOutput alloc] init];
	[dataOutput setAlwaysDiscardsLateVideoFrames:YES];
	
	[dataOutput setVideoSettings:[NSDictionary dictionaryWithObject: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
															 forKey: (id)kCVPixelBufferPixelFormatTypeKey]];
	
	self.captureVideoDataOutput = [dataOutput autorelease];
	
	
	if ([self.captureSession canAddOutput:self.captureVideoDataOutput]) {
		[self.captureSession addOutput:self.captureVideoDataOutput];
	} else {
		[NSException raise:@"SomethingWentWrongException" format:@"Could not could not add capture video data output as capture session output"];
	}
	
	[self.captureSession setSessionPreset:AVCaptureSessionPreset640x480];
	
	return self;
}


- (void)takePhotoWithCompletionHandler:(void (^)(UIImage *image))completion {
	if (self.captureStillImageOutput == nil) {
		AVCaptureStillImageOutput *output = [[AVCaptureStillImageOutput alloc] init];
		NSDictionary *outputSettings = [NSDictionary dictionaryWithObject:AVVideoCodecJPEG forKey:AVVideoCodecKey];
		[output setOutputSettings:outputSettings];
		
		if ([self.captureSession canAddOutput:output]) {
			[self.captureSession addOutput:output];
		}
		
		self.captureStillImageOutput = [output autorelease];
	}
	
	AVCaptureConnection *connection = nil;
	
	for (AVCaptureConnection *con in [self.captureStillImageOutput connections]) {
		if (connection) break;
		
		for (AVCaptureInputPort *inputPort in [con inputPorts]) {
			if ([inputPort.mediaType isEqual:AVMediaTypeVideo]) {
				connection = con;
				break;
			}
		}
	}
	
	if (!connection) {
		return;
	}
	
	if ([connection isVideoOrientationSupported]) {
/*		if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {*/
			[connection setVideoOrientation:[UIDevice currentDevice].orientation];
//		}
	}
	
	[self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
		if (imageDataSampleBuffer == NULL) {
			return;
		}
		
		NSData  *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
		UIImage *image = [UIImage imageWithData:imageData];
		
		dispatch_async(dispatch_get_main_queue(), ^(void) {
			completion(image);
		});
	}];
}


- (void)setSampleBufferDelegate:(id<AVCaptureVideoDataOutputSampleBufferDelegate>)delegate {
	[self.captureVideoDataOutput setSampleBufferDelegate:delegate queue:dispatch_get_main_queue()];
	
	if (delegate) {
		if (![self.captureSession isRunning]) {
			[self.captureSession startRunning];
		}
	} else {
		if ([self.captureSession isRunning]) {
			[self.captureSession stopRunning];
		}
	}
}


- (void)setFlash:(CamDeviceFlash)flashOn {
	flash = flashOn;
	
	for (AVCaptureDevice *device in [AVCaptureDevice devices]) {
		if (device.hasFlash) {
			AVCaptureFlashMode flashMode = (flash == CamDeviceFlashOn? AVCaptureFlashModeOn:
											flash == CamDeviceFlashOff? AVCaptureFlashModeOff:
											flash == CamDeviceFlashAuto? AVCaptureFlashModeAuto:
											AVCaptureFlashModeOff);
			
			if ([device isFlashModeSupported:flashMode]) {
				NSError *error = nil;
				[device lockForConfiguration:&error];
				if (error) {
					break;
				}
				device.flashMode = flashMode;
				[device unlockForConfiguration];
			}
		}
	}
}


+ (BOOL)hasFrontCamera {
	return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}


+ (BOOL)hasBackCamera {
	return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}


+ (BOOL)hasCamera {
	return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

@end
