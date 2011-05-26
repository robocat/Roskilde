//
//  CamViewController.h
//  Cam
//
//  Created by Ulrik Damm on 28/4/11.
//  Copyright 2011 ITU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	CamDeviceTypeFront,
	CamDeviceTypeBack,
} CamDeviceType;

typedef enum {
	CamDeviceFlashOn,
	CamDeviceFlashOff,
	CamDeviceFlashAuto,
} CamDeviceFlash;

@class AVCaptureDevice;
@class AVCaptureSession;
@class AVCaptureDeviceInput;
@class AVCaptureVideoDataOutput;
@class AVCaptureVideoPreviewLayer;
@class AVCaptureStillImageOutput;
@protocol AVCaptureVideoDataOutputSampleBufferDelegate;

@interface CamDevice : NSObject {
    AVCaptureDevice *captureDevice;
	AVCaptureSession *captureSession;
	AVCaptureDeviceInput *captureDeviceInput;
	AVCaptureVideoDataOutput *captureVideoDataOutput;
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
	AVCaptureStillImageOutput *captureStillImageOutput;
	
	CamDeviceFlash flash;
}

@property (nonatomic, assign) CamDeviceFlash flash;

- (id)initWithCameraType:(CamDeviceType)type;
- (void)setSampleBufferDelegate:(id<AVCaptureVideoDataOutputSampleBufferDelegate>)delegate;
- (void)takePhotoWithCompletionHandler:(void (^)(UIImage *image))completion;

@end
