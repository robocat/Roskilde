//
//  CamView.m
//  Cam
//
//  Created by Ulrik Damm on 28/4/11.
//  Copyright 2011 ITU. All rights reserved.
//

#import "CamView.h"
#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreMedia/CoreMedia.h>

@interface CamView ()

- (BOOL)initialize;

@property (nonatomic, retain) EAGLContext *context;

@end


@implementation CamView

@synthesize flipped;
@synthesize context;

- (void)dealloc {
	[self destroyFramebuffers];
	self.context = nil;
	
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		if (![self initialize]) {
			[self release];
			return nil;
		}
	}
	
	return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		if (![self initialize]) {
			[self release];
			return nil;
		}
	}
	
	return self;
}


- (BOOL)initialize {
	CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
	
	eaglLayer.opaque = YES;
	eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
									kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
									nil];		
	self.context = [[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1] autorelease];
	
	if (!self.context || ![EAGLContext setCurrentContext:self.context]) {
		[NSException raise:@"SomethingWentWrongException" format:@"Could not create OpenGL ES 1.0 context"];
		return NO;
	}
	
	[self createFramebuffers];
	
	return YES;
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
	
	CVImageBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
	
	CVPixelBufferLockBaseAddress(buffer, 0);
	int bufferHeight = CVPixelBufferGetHeight(buffer);
	int bufferWidth = CVPixelBufferGetWidth(buffer);
	
	glGenTextures(1, &videoFrameTexture);
	glBindTexture(GL_TEXTURE_2D, videoFrameTexture);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, bufferWidth, bufferHeight, 0, GL_BGRA, GL_UNSIGNED_BYTE, CVPixelBufferGetBaseAddress(buffer));
	
	[self draw];
	
	glDeleteTextures(1, &videoFrameTexture);
	
	CVPixelBufferUnlockBaseAddress(buffer, 0);
}


- (void)createFramebuffers {
	glEnable(GL_TEXTURE_2D);
	glDisable(GL_DEPTH_TEST);
	
	glGenFramebuffersOES(1, &viewFramebuffer);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
	glGenRenderbuffersOES(1, &viewRenderbuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	
	[self.context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
	
	if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
		[NSException raise:@"SomethingWentWrongException" format:@"Could not create framebuffer with renderbuffer"];
	}
	
	glGenFramebuffersOES(1, &positionFramebuffer);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, positionFramebuffer);
	
	glGenRenderbuffersOES(1, &positionRenderbuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, positionRenderbuffer);
	
    glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_RGBA8_OES, CamViewBackingWidth, CamViewBackingHeight);
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, positionRenderbuffer);	
    
	
	glGenTextures(1, &positionRenderTexture);
    glBindTexture(GL_TEXTURE_2D, positionRenderTexture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glHint(GL_GENERATE_MIPMAP_HINT, GL_NICEST);
	
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, CamViewBackingWidth, CamViewBackingHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
	
	glFramebufferTexture2DOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_TEXTURE_2D, positionRenderTexture, 0);
	
	
	GLenum status = glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES);
    if (status != GL_FRAMEBUFFER_COMPLETE_OES) {
		[NSException raise:@"SomethingWentWrongException" format:@"Could not create framebuffer with offscreen renderbuffer"];
    }
}


- (void)destroyFramebuffers {
	if (viewFramebuffer) {
		glDeleteFramebuffersOES(1, &viewFramebuffer);
		viewFramebuffer = 0;
	}
	
	if (viewRenderbuffer) {
		glDeleteRenderbuffersOES(1, &viewRenderbuffer);
		viewRenderbuffer = 0;
	}
}


- (void)draw {
	static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };
	
	static const GLfloat flippedSquareVertices[] = {
        1.0f, -1.0f,
        -1.0f, -1.0f,
        1.0f,  1.0f,
        -1.0f,  1.0f,
    };
	
	static const GLfloat textureVertices[] = {
        1.0f, 1.0f,
        1.0f, 0.0f,
        0.0f,  1.0f,
        0.0f,  0.0f,
    };
	
	if (!viewFramebuffer) {
		[self createFramebuffers];
	}
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glViewport(0, 0, backingWidth, backingHeight);
	
	
	glBindTexture(GL_TEXTURE_2D, videoFrameTexture);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, (self.flipped? flippedSquareVertices: squareVertices));
	glTexCoordPointer(2, GL_FLOAT, 0, textureVertices);
	
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	if (self.context) {
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
        
        if (![self.context presentRenderbuffer:GL_RENDERBUFFER_OES]) {
			[NSException raise:@"SomethingWentWrongException" format:@"Could not present renderbuffer"];
		}
    }
}


+ (Class)layerClass {
	return [CAEAGLLayer class];
}

@end
