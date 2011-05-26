//
//  CamView.h
//  Cam
//
//  Created by Ulrik Damm on 28/4/11.
//  Copyright 2011 ITU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <AVFoundation/AVFoundation.h>

#define CamViewBackingWidth 320
#define CamViewBackingHeight 480

@interface CamView : UIView <AVCaptureVideoDataOutputSampleBufferDelegate> {
    GLint backingWidth;
	GLint backingHeight;
	
	GLuint viewRenderbuffer;
	GLuint viewFramebuffer;
	
	GLuint positionRenderTexture;
	GLuint positionRenderbuffer;
	GLuint positionFramebuffer;
	
	GLuint videoFrameTexture;
	
	BOOL flipped;
}

@property (nonatomic, assign, getter = isFlipped) BOOL flipped;

- (void)createFramebuffers;
- (void)destroyFramebuffers;
- (void)draw;

@end
