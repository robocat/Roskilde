//
//  CamPreviewController.m
//  XKamera
//
//  Created by Ulrik Damm on 5/5/11.
//  Copyright 2011 ITU. All rights reserved.
//

#import "CamPreviewController.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>

@interface CamPreviewController ()

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, retain) NSArray *scrollviews;
@property (nonatomic, retain) UITapGestureRecognizer *hideUploadviewGesture;
@property (nonatomic, retain) UITapGestureRecognizer *showUploadGesture;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;

- (void)stopUpload:(id)sender;
- (void)removeKeyboard:(id)sender;
- (void)stopOrHideKeyboard:(id)sender;

@end


@implementation CamPreviewController

@synthesize image;
@synthesize images;
@synthesize uploadView;
@synthesize hideUploadviewGesture;
@synthesize showUploadGesture;
@synthesize previewView;
@synthesize descriptionPlaceholder;
@synthesize description;
@synthesize location;
@synthesize scrollView;
@synthesize locationManager;
@synthesize reverseGeocoder;
@synthesize navbar;
@synthesize delegate;
@synthesize pageControl;
@synthesize scrollviews;

- (void)viewDidUnload {
	self.uploadView = nil;
	self.hideUploadviewGesture = nil;
	self.previewView = nil;
	self.descriptionPlaceholder = nil;
	self.description = nil;
	self.locationManager = nil;
	self.reverseGeocoder = nil;
	self.image = nil;
	
	[self setLocation:nil];
	[self setScrollView:nil];
	[self setPageControl:nil];
	[self setPageControl:nil];
	[super viewDidUnload];
}


- (id)initWithImages:(NSArray*)initimages selectedIndex:(NSUInteger)index {
	if ((self = [super init])) {
		self.images = initimages;
		selectedIndex = index;
		self.scrollviews = nil;
	}
	
	return self;
}


#pragma mark interface


- (void)viewDidLoad {
	if ([self.images count] > 1) {
		self.pageControl.numberOfPages = [self.images count];
		self.pageControl.currentPage = selectedIndex;
	} else {
		self.pageControl.hidden = YES;
	}
	
	self.uploadView.frame = CGRectMake(0, -220, self.view.frame.size.width, 200);
	
	self.uploadView.layer.shadowColor = [UIColor blackColor].CGColor;
	self.uploadView.layer.shadowOffset = CGSizeMake(0, 10);
	self.uploadView.layer.shadowRadius = 10;
	self.uploadView.layer.shadowOpacity = 1;
	
	CGMutablePathRef shadowPath = CGPathCreateMutable();
	CGPathAddRect(shadowPath, NULL, CGRectMake(-20, 0, self.view.frame.size.width+20, 200));
	self.uploadView.layer.shadowPath = shadowPath;
	CGPathRelease(shadowPath);
	
	
	self.hideUploadviewGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopOrHideKeyboard:)] autorelease];
	self.hideUploadviewGesture.numberOfTapsRequired = 1;
	self.hideUploadviewGesture.numberOfTouchesRequired = 1;
	
	self.showUploadGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upload:)] autorelease];
	self.showUploadGesture.numberOfTapsRequired = 1;
	self.showUploadGesture.numberOfTouchesRequired = 1;
	[self.scrollView addGestureRecognizer:self.showUploadGesture];
	
	
	UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*[self.images count]+1, self.scrollView.frame.size.height)];
	
	NSMutableArray *imagescrollviews = [NSMutableArray arrayWithCapacity:5];
	
	int i;
	for (i = 0; i < [self.images count]; i++) {
		UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(320*i, 0, self.view.bounds.size.width, self.scrollView.bounds.size.height)];
		imageScrollView.delegate = self;
		imageScrollView.maximumZoomScale = 3.0;
		imageScrollView.minimumZoomScale = 1.0;
		imageScrollView.canCancelContentTouches = YES;
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.scrollView.bounds.size.height)];
		imageView.image = [self.images objectAtIndex:i];
		imageScrollView.clipsToBounds = YES;
		
		if (imageView.image.size.width > imageView.image.size.height) {
			imageView.contentMode = UIViewContentModeScaleAspectFit;
		}
		
		[imageScrollView addSubview:imageView];
		[contentView addSubview:imageScrollView];
		[imageView release];
		
		[imagescrollviews addObject:imageScrollView];
		[imageScrollView release];
	}
	
	self.scrollviews = imagescrollviews;
	
	[self.scrollView addSubview:contentView];
	self.scrollView.contentSize = contentView.frame.size;
	
	[contentView release];
	
	[self.scrollView scrollRectToVisible:CGRectMake(320*selectedIndex, 0, 320, self.scrollView.frame.size.height) animated:NO];
}


- (IBAction)upload:(id)sender {
	self.scrollView.scrollEnabled = NO;
	
	[self.view addSubview:self.uploadView];
	
	[self.scrollView removeGestureRecognizer:self.showUploadGesture];
	[self.scrollView addGestureRecognizer:self.hideUploadviewGesture];
	
	[UIView animateWithDuration:0.3 animations:^(void) {
		self.uploadView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
		self.previewView.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height);
	}];
}


- (void)stopUpload:(id)sender {
	self.scrollView.scrollEnabled = YES;
	
	[self.scrollView removeGestureRecognizer:self.hideUploadviewGesture];
	[self.scrollView addGestureRecognizer:self.showUploadGesture];
	
	[self.description resignFirstResponder];
	[self.location resignFirstResponder];
	
	[UIView animateWithDuration:0.3 animations:^(void) {
		self.uploadView.frame = CGRectMake(0, -220, self.view.frame.size.width, 200);
		self.previewView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	} completion:^(BOOL finished) {
		[self.uploadView removeFromSuperview];
	}];
}


- (void)removeKeyboard:(id)sender {
	[self.description resignFirstResponder];
	[self.location resignFirstResponder];
}


- (void)stopOrHideKeyboard:(id)sender {
	if ([self.description isFirstResponder] || [self.location isFirstResponder]) {
		[self removeKeyboard:sender];
	} else {
		[self stopUpload:sender];
	}
}


- (IBAction)back:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark networking


- (IBAction)performUpload:(id)sender {
	NSString *urlString = [NSString stringWithFormat:@"%@/entries/", kXdkAPIBaseUrl];
	NSURL *url = [NSURL URLWithString:urlString];
	
	UIView *waitView = [[UIView alloc] initWithFrame:self.uploadView.bounds];
	waitView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
	UILabel *waitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 320, 20)];
	waitLabel.textAlignment = UITextAlignmentCenter;
	waitLabel.text = @"Uploading...";
	waitLabel.textColor = [UIColor whiteColor];
	waitLabel.shadowColor = [UIColor blackColor];
	waitLabel.shadowOffset = CGSizeMake(0, 1);
	waitLabel.backgroundColor = [UIColor clearColor];
	[waitView addSubview:waitLabel];
	[self.uploadView addSubview:waitView];
	
	__block ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:url];
	[formRequest setPostValue:@"Willi"				forKey:@"username"];
	[formRequest setPostValue:@"ww"					forKey:@"password"];
	[formRequest setPostValue:self.description.text	forKey:@"message"];
	[formRequest setPostValue:self.location.text	forKey:@"location"];
	[formRequest setPostValue:@"iPhone"				forKey:@"source"];
	
	
	// Prepare image
	NSString *filename = [NSString stringWithFormat:@"%@-iphone.jpg", @"willi"];
	UIImage *currentImage = [self.images objectAtIndex:self.pageControl.currentPage];
	NSData *imageData = UIImageJPEGRepresentation(currentImage, (currentImage.size.width > 640? 0.3: 1.0));
	[formRequest setPostValue:[NSNumber numberWithFloat:currentImage.size.width] forKey:@"width"];
	[formRequest setPostValue:[NSNumber numberWithFloat:currentImage.size.height] forKey:@"height"];
	[formRequest setData:imageData withFileName:filename andContentType:@"image/jpeg" forKey:@"media"];
	
	[formRequest setCompletionBlock:^{
		// Use when fetching text data
		NSString *responseString = [formRequest responseString];
		int statusCode = [formRequest responseStatusCode];
		LOG_EXPR(statusCode);
		LOG_EXPR(responseString);
		
		if (statusCode == 200) {
			waitLabel.text = @":D";
		} else {
			waitLabel.text = @":(";
		}
		
		[UIView animateWithDuration:0.3 delay:1 options:0 animations:^(void) {
			waitView.alpha = 0;
		} completion:^(BOOL finished) {
			if (self.delegate && [self.delegate respondsToSelector:@selector(CamPreview:didSucceedUploadingIndex:)]) {
				[self.delegate CamPreview:self didSucceedUploadingIndex:selectedIndex];
			}
			
			[waitView removeFromSuperview];
			[self back:self];
		}];
	}];
	
	[formRequest setFailedBlock:^{
		NSError *error = [formRequest error];
		NSLog(@"error: %@", error);
		
		waitLabel.text = @":(";
		[UIView animateWithDuration:0.3 delay:1 options:0 animations:^(void) {
			waitView.alpha = 0;
		} completion:^(BOOL finished) {
			if (self.delegate && [self.delegate respondsToSelector:@selector(CamPreview:didFailUploadingIndex:)]) {
				[self.delegate CamPreview:self didFailUploadingIndex:selectedIndex];
			}
			
			[waitView removeFromSuperview];
			[self back:self];
		}];
	}];
	
	[formRequest startAsynchronous];
	
	[waitView release];
	[waitLabel release];
}


#pragma mark delegate methods


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)tmpscrollView {
	if ([self.scrollviews containsObject:tmpscrollView]) {
		return [[tmpscrollView subviews] objectAtIndex:0];
	}
	
	return nil;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)tmpscrollView {
	if ([self.scrollviews containsObject:tmpscrollView]) {
		return;
	}
	
	int scrollviewindex = tmpscrollView.contentOffset.x/320;
	
	int i;
	for (i = 0; i < [self.scrollviews count]; i++) {
		if (i != scrollviewindex) {
			[[self.scrollviews objectAtIndex:i] setZoomScale:1.0];
		}
	}
	
	self.pageControl.currentPage = self.scrollView.contentOffset.x/320;
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
	self.descriptionPlaceholder.hidden = YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView {
	if ([textView.text isEqualToString:@""]) {
		self.descriptionPlaceholder.hidden = NO;
	}
}


- (void)dealloc {
	[descriptionPlaceholder release];
	[description release];
	[location release];
	[scrollView release];
	[pageControl release];
	[pageControl release];
	[super dealloc];
}

@end
