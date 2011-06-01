//
//  UIImageHelper.m
//  Enormego Cocoa Helpers
//
//  Created by Devin Doty on 1/13/2010.
//  Copyright (c) 2008-2009 enormego
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#if TARGET_OS_IPHONE
#import "UIImageHelper.h"
#import <CoreGraphics/CoreGraphics.h>
#import "UIImage-Extensions.h"

@implementation UIImage (Helper)

static inline CGFloat degreesToRadiens(CGFloat degrees){
	return degrees * M_PI / 180.0f;
}

+ (UIImage*)imageWithContentsOfURL:(NSURL*)url {
	NSError* error = nil;
	NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:NULL error:NULL];
	if(error || !data) {
		return nil;
	} else {
		return [UIImage imageWithData:data];
	}
}

+ (UIImage*)imageWithResourcesPathCompontent:(NSString*)pathCompontent {
	return [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:pathCompontent]];
}

- (UIImage*)scaleToSize:(CGSize)size {
	
	UIGraphicsBeginImageContext(size);
	[self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return scaledImage;
}

- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withBorderSize:(CGFloat)borderSize borderColor:(UIColor*)aColor cornerRadius:(CGFloat)aRadius shadowOffset:(CGSize)aOffset shadowBlurRadius:(CGFloat)aBlurRadius shadowColor:(UIColor*)aShadowColor{
	
	CGSize imageSize = CGSizeMake(self.size.width, self.size.height);
	
	CGFloat hScaleFactor = imageSize.width / size;
	CGFloat vScaleFactor = imageSize.height / size;
	
	CGFloat scaleFactor = MAX(hScaleFactor, vScaleFactor);
	
	CGFloat newWidth = imageSize.width   / scaleFactor;
	CGFloat newHeight = imageSize.height / scaleFactor;
	
	CGRect imageRect = CGRectMake(0.0f, 0.0f, (newWidth + floorf((borderSize*2.0))), (newHeight + floorf((borderSize*2.0))));
	
	UIGraphicsBeginImageContext(CGSizeMake(imageRect.size.width, imageRect.size.height));
	
	CGContextRef imageContext = UIGraphicsGetCurrentContext();
	
	if (aRadius > 0.0f) {
		
		CGFloat radius;	
		radius = MIN(aRadius, floorf(imageRect.size.width/2));
		float x0 = CGRectGetMinX(imageRect), y0 = CGRectGetMinY(imageRect), x1 = CGRectGetMaxX(imageRect), y1 = CGRectGetMaxY(imageRect);
		
		CGContextBeginPath(imageContext);
		CGContextMoveToPoint(imageContext, x0+radius, y0);
		CGContextAddArcToPoint(imageContext, x1, y0, x1, y1, radius);
		CGContextAddArcToPoint(imageContext, x1, y1, x0, y1, radius);
		CGContextAddArcToPoint(imageContext, x0, y1, x0, y0, radius);
		CGContextAddArcToPoint(imageContext, x0, y0, x1, y0, radius);
		CGContextClosePath(imageContext);
		CGContextClip(imageContext);
		
	}
	
	[self drawInRect:CGRectMake(borderSize, borderSize, newWidth, newHeight)];
	
	if (aColor) {
		[aColor setStroke];
		CGContextSetLineWidth(imageContext, borderSize);
		CGContextStrokeRect(imageContext, imageRect);
	}
	
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	

	
	//  if shadow property is set, redraw image with a shadow
	if (aBlurRadius > 0.0f) {
		UIGraphicsBeginImageContext(CGSizeMake(scaledImage.size.width + (aBlurRadius*2), scaledImage.size.height + (aBlurRadius*2)));
		CGContextRef imageShadowContext = UIGraphicsGetCurrentContext();
		CGContextSetShadowWithColor(imageShadowContext, aOffset, aBlurRadius, aShadowColor.CGColor);
		[scaledImage drawInRect:CGRectMake(aBlurRadius, aBlurRadius, scaledImage.size.width, scaledImage.size.height)];
		scaledImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
	}
	
	return scaledImage;	
}

- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withShadowOffset:(CGSize)aOffset blurRadius:(CGFloat)aRadius color:(UIColor*)aColor{
	return [self aspectScaleToMaxSize:size	withBorderSize:0 borderColor:nil cornerRadius:0 shadowOffset:aOffset shadowBlurRadius:aRadius shadowColor:aColor];
}

- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withCornerRadius:(CGFloat)aRadius{
	
	return [self aspectScaleToMaxSize:size withBorderSize:0 borderColor:nil cornerRadius:aRadius shadowOffset:CGSizeZero shadowBlurRadius:0.0f shadowColor:nil];
}

- (UIImage*)aspectScaleToMaxSize:(CGFloat)size{
	
	return [self aspectScaleToMaxSize:size withBorderSize:0 borderColor:nil cornerRadius:0 shadowOffset:CGSizeZero shadowBlurRadius:0.0f shadowColor:nil];
}

- (UIImage*)aspectScaleToSize:(CGSize)size{
	
	CGSize imageSize = CGSizeMake(self.size.width, self.size.height);
	
	CGFloat hScaleFactor = imageSize.width / size.width;
	CGFloat vScaleFactor = imageSize.height / size.height;
	
	CGFloat scaleFactor = MAX(hScaleFactor, vScaleFactor);
	
	CGFloat newWidth = imageSize.width   / scaleFactor;
	CGFloat newHeight = imageSize.height / scaleFactor;
	
	// center vertically or horizontally in size passed
	CGFloat leftOffset = (size.width - newWidth) / 2;
	CGFloat topOffset = (size.height - newHeight) / 2;
	
	UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
	[self drawInRect:CGRectMake(leftOffset, topOffset, newWidth, newHeight)];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return scaledImage;	
}

- (void)drawInRect:(CGRect)rect withAlphaMaskColor:(UIColor*)aColor{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	
	CGContextTranslateCTM(context, 0.0, rect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	rect.origin.y = rect.origin.y * -1;
	const CGFloat *color = CGColorGetComponents(aColor.CGColor);
	CGContextClipToMask(context, rect, self.CGImage);
	CGContextSetRGBFillColor(context, color[0], color[1], color[2], color[3]);
	CGContextFillRect(context, rect);
	
	CGContextRestoreGState(context);
}


- (void)drawInRect:(CGRect)rect withAlphaMaskGradient:(NSArray*)colors{
	
	NSAssert([colors count]==2, @"an array containing two UIColor variables must be passed to drawInRect:withAlphaMaskGradient:");
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	
	CGContextTranslateCTM(context, 0.0, rect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	rect.origin.y = rect.origin.y * -1;
	
	CGContextClipToMask(context, rect, self.CGImage);
	
	const CGFloat *top = CGColorGetComponents(((UIColor*)[colors objectAtIndex:0]).CGColor);
	const CGFloat *bottom = CGColorGetComponents(((UIColor*)[colors objectAtIndex:1]).CGColor);
	
	CGColorSpaceRef _rgb = CGColorSpaceCreateDeviceRGB();
	size_t _numLocations = 2;
	CGFloat _locations[2] = { 0.0, 1.0 };
	CGFloat _colors[8] = { top[0], top[1], top[2], top[3], bottom[0], bottom[1], bottom[2], bottom[3] };
	CGGradientRef gradient = CGGradientCreateWithColorComponents(_rgb, _colors, _locations, _numLocations);
	CGColorSpaceRelease(_rgb);
	
	CGPoint start = CGPointMake(CGRectGetMidX(rect), rect.origin.y);
	CGPoint end = CGPointMake(CGRectGetMidX(rect), rect.size.height);
	
	CGContextClipToRect(context, rect);
	CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(gradient);
	
	CGContextRestoreGState(context);
	
}





- (UIImage *)addBorder {
	UIImage * border = [UIImage imageNamed:@"imageBg.png"];
	CGSize borderSize = CGSizeMake(border.size.width, border.size.height);
	
	UIGraphicsBeginImageContext(borderSize);
//	UIGraphicsBeginImageContextWithOptions(borderSize, NO, 2.0);
	
	CGPoint borderPoint = CGPointMake(0, 0);
	[border drawAtPoint:borderPoint];
	
	CGFloat x = 10.0f;
	CGFloat y = 10.0f;
	
	CGFloat imgWidth = (self.size.width > 400.0f) ? 400.0f : self.size.width;
	CGFloat imgHeight = (self.size.height > 300.0f) ? 300.0f : self.size.height;
	
	if (imgWidth < 400.0f) {
		x += roundf((400.0f - imgWidth) / 2.0f);
	}
	
	if (imgHeight < 300.0f) {
		y += roundf((300.0f - imgHeight) / 2.0f);
	}
	
	[self drawInRect:CGRectMake(x, y, imgWidth, imgHeight)];
	
	UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return result;
}


//- (UIImage *)addBorder {
//	UIImage * border = [UIImage imageNamed:@"imageBg.png"];
//	CGSize borderSize = CGSizeMake(CGImageGetWidth([border CGImage]), CGImageGetHeight([border CGImage]));
//	
//	NSLog(@"%@", NSStringFromCGSize(borderSize));
//	
////	UIGraphicsBeginImageContext(borderSize);
//	UIGraphicsBeginImageContextWithOptions(borderSize, NO, 0);
//	
//	CGPoint borderPoint = CGPointMake(0, 0);
//	[border drawAtPoint:borderPoint];
//	
//	CGFloat x = 10.0f;
//	CGFloat y = 10.0f;
//	
////	CGFloat imgWidth = (self.size.width > 400.0f) ? 400.0f : self.size.width;
////	CGFloat imgHeight = (self.size.height > 300.0f) ? 300.0f : self.size.height;
////	
////	if (imgWidth < 400.0f) {
////		x += roundf((400.0f - imgWidth) / 2.0f);
////	}
////	
////	if (imgHeight < 300.0f) {
////		y += roundf((300.0f - imgHeight) / 2.0f);
////	}
//	
//	[self drawInRect:CGRectMake(x, y, borderSize.width/border.scale, borderSize.height/border.scale)];
//	
//	UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//	
//	return result;
//}


//- (UIImage *)addBorderAvatar {
//	UIImage * border = [UIImage imageNamed:@"avatarblank.png"];
//	CGImageRef borderImg = [border CGImage];
//	CGSize borderSize = CGSizeMake(CGImageGetWidth(borderImg), CGImageGetHeight(borderImg));
//	
//	CGFloat borderScale = border.scale;
//	CGFloat imgScale = 40.0f * border.scale;
//	CGFloat x = 4.0f * borderScale;
//	CGFloat y = 4.0f * borderScale;
//	
//	UIGraphicsBeginImageContextWithOptions(borderSize, NO, 0.0f);
//	
//	[border drawInRect:CGRectMake(0.0f, 0.0f, borderSize.width, borderSize.height)];
//	
//	CGFloat imgWidth = CGImageGetWidth([self CGImage]);
//	imgWidth = (imgWidth > imgScale) ? imgScale : imgWidth;
//	CGFloat imgHeight = CGImageGetHeight([self CGImage]);
//	imgHeight = (imgHeight > imgScale) ? imgScale : imgHeight;
//	
//	if (imgWidth < imgScale) {
//		x += roundf((imgScale - imgWidth) / 2.0f);
//	}
//	
//	if (imgHeight < imgScale) {
//		y += roundf((imgScale - imgHeight) / 2.0f);
//	}
//	
//	[self drawInRect:CGRectMake(x, y, imgWidth, imgHeight)];
//	
//	UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//	
//	return result;
//}

- (UIImage *)addBorderAvatar {
	UIImage * border = [UIImage imageNamed:@"noavatar@2x.png"];
	CGSize borderSize = CGSizeMake(border.size.width, border.size.height);
	
	UIGraphicsBeginImageContext(borderSize);
//	UIGraphicsBeginImageContextWithOptions(borderSize, NO, 0.0);
	
	[border drawInRect:CGRectMake(0.0f, 0.0f, borderSize.width, borderSize.height)];
	
	CGFloat x = 8.0f;
	CGFloat y = 8.0f;
	
	CGFloat imgWidth = (self.size.width > 80.0f) ? 80.0f : self.size.width;
	CGFloat imgHeight = (self.size.height > 80.0f) ? 80.0f : self.size.height;
	
	if (imgWidth < 80.0f) {
		x += roundf((80.0f - imgWidth) / 2.0f);
	}
	
	if (imgHeight < 80.0f) {
		y += roundf((80.0f - imgHeight) / 2.0f);
	}
	
	[self drawInRect:CGRectMake(x, y, imgWidth, imgHeight)];
	
	UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return result;
}



- (UIImage *) rotate:(CGFloat) radians {
	CGImageRef image = self.CGImage;
	CGSize size = CGSizeMake(self.size.width, self.size.height);;
	UIGraphicsBeginImageContext(size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextRotateCTM(ctx, radians);
	CGContextDrawImage(UIGraphicsGetCurrentContext(),
					   CGRectMake(0,0,size.width, size.height),
					   image);
	UIImage *copy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return copy;
}


- (UIImage*)imageWithBorderFromImage:(UIImage*)source
{
	CGSize size = [source size];
	UIGraphicsBeginImageContext(size);
	CGRect rect = CGRectMake(0, 0, size.width+1, size.height+1);
	[source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBStrokeColor(context, 1.0, 0.5, 1.0, 1.0); 
	CGContextStrokeRect(context, rect);
	UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return testImg;
}


- (UIImage*)stretchableImageWithHorizontalCapWith:(CGFloat)horizontalCapWith verticalCapWith:(CGFloat)verticalCapWith 
{
	CGSize newSize = CGSizeMake(horizontalCapWith * 2.0 + 1.0, verticalCapWith * 2.0 + 1.0);
	
	UIGraphicsBeginImageContext(newSize);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	// upper left cap + 1 px middle
	CGContextSaveGState(ctx);
	CGContextAddRect(ctx, CGRectMake(0, 0, horizontalCapWith + 1.0, verticalCapWith + 1.0));
	CGContextClip(ctx);
	[self drawInRect:CGRectMake(0,0,self.size.width,self.size.height)];
	CGContextRestoreGState(ctx);
	
	// lower left cap
	CGContextSaveGState(ctx);
	CGContextAddRect(ctx, CGRectMake(0, verticalCapWith + 1.0, horizontalCapWith + 1.0, verticalCapWith));
	CGContextClip(ctx);
	[self drawInRect:CGRectMake(0,newSize.height - self.size.height,self.size.width,self.size.height)];
	CGContextRestoreGState(ctx);
	
	// upper right cap
	CGContextSaveGState(ctx);
	CGContextAddRect(ctx, CGRectMake(horizontalCapWith + 1.0, 0, horizontalCapWith, verticalCapWith+1.0));
	CGContextClip(ctx);
	[self drawInRect:CGRectMake(newSize.width - self.size.width,0,self.size.width,self.size.height)];
	CGContextRestoreGState(ctx);
	
	// lower right cap
	CGContextSaveGState(ctx);
	CGContextAddRect(ctx, CGRectMake(horizontalCapWith + 1.0, verticalCapWith + 1.0, horizontalCapWith, verticalCapWith));
	CGContextClip(ctx);
	[self drawInRect:CGRectMake(newSize.width - self.size.width,newSize.height - self.size.height,self.size.width,self.size.height)];
	CGContextRestoreGState(ctx);
	
	// static image
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return [newImage stretchableImageWithLeftCapWidth:horizontalCapWith topCapHeight:verticalCapWith];
}

@end
#endif