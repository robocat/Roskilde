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
#import "LocationManager.h"
#import "JSONKit.h"
#import "RFCreateProfileViewController.h"
#import "ATMHud.h"
#import "RFModelController.h"


@interface CamPreviewController ()

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, retain) NSArray *scrollviews;
@property (nonatomic, retain) UITapGestureRecognizer *hideUploadviewGesture;
@property (nonatomic, retain) UITapGestureRecognizer *showUploadGesture;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;
@property (nonatomic, retain) NSArray *nearLocations;
@property (nonatomic, retain) UITableView *tableView;

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
@synthesize locationTextField;
@synthesize scrollView;
@synthesize locationManager;
@synthesize navbar;
@synthesize delegate;
@synthesize pageControl;
@synthesize locationButton;
@synthesize scrollviews;
@synthesize nearLocations;
@synthesize tableView;
@synthesize replyTo;
@synthesize reverseGeocoder;
@synthesize currentLocation;


- (void)viewDidUnload {
	self.uploadView = nil;
	self.hideUploadviewGesture = nil;
	self.previewView = nil;
	self.descriptionPlaceholder = nil;
	self.description = nil;
	self.locationManager = nil;
	self.reverseGeocoder = nil;
	self.image = nil;
	self.nearLocations = nil;
	self.reverseGeocoder = nil;
	
	[self setLocationTextField:nil];
	[self setScrollView:nil];
	[self setPageControl:nil];
	[self setPageControl:nil];
	[self setLocationButton:nil];
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
	
	// Custom navbar
	[self.navbar setBackgroundWith:[UIImage imageNamed:@"altnavbar.png"]];
	
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
	
	self.currentLocation = nil;
	self.reverseGeocoder = nil;
	
	self.locationButton.hidden = YES;
	
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	self.locationManager.delegate = self;
	[self.locationManager startUpdatingLocation];
    
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"upload_complete" ofType:@"caf"]], &uploadCompleteSound);
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	self.navigationController.navigationBarHidden = YES;
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
	[self.locationTextField resignFirstResponder];
	
	[UIView animateWithDuration:0.3 animations:^(void) {
		self.uploadView.frame = CGRectMake(0, -220, self.view.frame.size.width, 200);
		self.previewView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	} completion:^(BOOL finished) {
		[self.uploadView removeFromSuperview];
	}];
}


- (void)removeKeyboard:(id)sender {
	[self.description resignFirstResponder];
	[self.locationTextField resignFirstResponder];
	
	self.locationButton.hidden = NO;
}


- (void)stopOrHideKeyboard:(id)sender {
	if ([self.description isFirstResponder] || [self.locationTextField isFirstResponder]) {
		[self removeKeyboard:sender];
	} else {
		[self stopUpload:sender];
	}
}


- (IBAction)back:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)chooseLocation:(id)sender {
	if (self.tableView) {
		[UIView animateWithDuration:0.3 animations:^(void) {
			self.tableView.frame = CGRectOffset(self.tableView.frame, 0, -(self.view.frame.size.height - self.uploadView.frame.size.height));
		} completion:^(BOOL finished) {
			[self.tableView removeFromSuperview];
			self.tableView = nil;
		}];
		
		return;
	}
	
	[self.locationTextField resignFirstResponder];
	
	self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, -(self.view.frame.size.height - self.uploadView.frame.size.height*2), 320, self.view.frame.size.height - self.uploadView.frame.size.height) style:UITableViewStylePlain] autorelease];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	
	[self.view insertSubview:self.tableView belowSubview:self.uploadView];
	
	self.tableView.layer.shadowColor = [UIColor blackColor].CGColor;
	self.tableView.layer.shadowOffset = CGSizeMake(0, 10);
	self.tableView.layer.shadowRadius = 10;
	self.tableView.layer.shadowOpacity = 1;
	
	CGMutablePathRef shadowPath = CGPathCreateMutable();
	CGPathAddRect(shadowPath, NULL, CGRectMake(-20, 0, self.view.frame.size.width+20, self.tableView.frame.size.height));
	self.tableView.layer.shadowPath = shadowPath;
	CGPathRelease(shadowPath);
	
	[UIView animateWithDuration:0.3 animations:^(void) {
		self.tableView.frame = CGRectOffset(self.tableView.frame, 0, self.uploadView.frame.size.height - self.tableView.frame.origin.y);
	}];
}


#pragma mark networking

- (void)createProfile {
	RFCreateProfileViewController *controller = [[RFCreateProfileViewController alloc] initWithNibName:@"RFCreateProfileViewController" bundle:nil];
	self.navigationController.navigationBarHidden = NO;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	
}

- (IBAction)performUpload:(id)sender {
	if (![RFGlobal username]) {
		[self createProfile];
		return;
	}
	
	[self removeKeyboard:self];
	
	NSString *urlString = [NSString stringWithFormat:@"%@/entries/", kXdkAPIBaseUrl];
	NSURL *url = [NSURL URLWithString:urlString];
	
/*	UIView *waitView = [[UIView alloc] initWithFrame:self.uploadView.bounds];
	waitView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
	UILabel *waitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 320, 20)];
	waitLabel.textAlignment = UITextAlignmentCenter;
	waitLabel.text = @"Uploading...";
	waitLabel.textColor = [UIColor whiteColor];
	waitLabel.shadowColor = [UIColor blackColor];
	waitLabel.shadowOffset = CGSizeMake(0, 1);
	waitLabel.backgroundColor = [UIColor clearColor];
	[waitView addSubview:waitLabel];
	[self.uploadView addSubview:waitView];*/
	
	
	UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
	UIView *darkView = [[UIView alloc] initWithFrame:mainWindow.bounds];
	darkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.2];
	[mainWindow addSubview:darkView];
	
	
	ATMHud *hud = [[ATMHud alloc] initWithDelegate:self];
	[hud setCaption:@"Uploading photo..."];
	[hud setProgress:0];
	[[[UIApplication sharedApplication] keyWindow] addSubview:[hud view]];
	[hud show];
	
	
	// Prepare data
	
	NSString * comment = (self.description.text) ? self.description.text : @"";
	NSString * loc = (self.locationTextField.text) ? self.locationTextField.text : @"";
	
	NSMutableDictionary *data = [NSMutableDictionary dictionaryWithCapacity:6];
	[data setObject:[RFGlobal username] forKey:@"username"];
	[data setObject:[RFGlobal password] forKey:@"password"];
	[data setObject:comment forKey:@"comment"];
	[data setObject:@"roskilde-festival" forKey:@"tags"];
	[data setObject:loc forKey:@"location"];
	[data setObject:@"Roskilde app" forKey:@"via"];
	
	if (!self.replyTo) {
		self.replyTo = @"";
	}
	[data setObject:self.replyTo forKey:@"reply_to"];
	
	NSString *json = [data JSONString];
	
	// Prepare image
	NSString *filename = [NSString stringWithFormat:@"%@-roskildeapp.jpg", [RFGlobal username]];
	UIImage *currentImage = [self.images objectAtIndex:self.pageControl.currentPage];
	NSData *imageData = UIImageJPEGRepresentation(currentImage, 1.0/*(currentImage.size.width > 640? 0.3: 1.0)*/);
	
	__block ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:url];
    
    // Disabling secure certificate validation
    [formRequest setValidatesSecureCertificate:NO];
    
    // Set timeout to 30 secs
    [formRequest setTimeOutSeconds:30];
    
	[formRequest setPostValue:json forKey:@"data"];
	[formRequest setPostValue:[NSNumber numberWithFloat:currentImage.size.width] forKey:@"width"];
	[formRequest setPostValue:[NSNumber numberWithFloat:currentImage.size.height] forKey:@"height"];
	[formRequest setData:imageData withFileName:filename andContentType:@"image/jpeg" forKey:@"media"];
	
	// Basic Auth
	NSString *auth = [NSString stringWithFormat:@"Basic %@",[ASIHTTPRequest base64forData:[[NSString stringWithFormat:@"%@:%@", [RFGlobal username], [RFGlobal password]] dataUsingEncoding:NSUTF8StringEncoding]]];
	[formRequest addRequestHeader:@"Authorization" value:auth];
	
	[formRequest setHeadersReceivedBlock:^(NSDictionary *responseHeaders) {
		NSLog(@"response: %@", responseHeaders);
	}];
	
	__block CGFloat progress = 0;
	
	[formRequest setBytesSentBlock:^(unsigned long long size, unsigned long long total) {
//		NSLog(@"size:%lld total:%lld, fsize:%f ftotal:%f progress:%f", size, total, (CGFloat)size, (CGFloat)total, ((CGFloat)total)/((CGFloat)size));
		[hud setProgress:(progress += ((CGFloat)size)/((CGFloat)total))];
	}];
	
	[formRequest setCompletionBlock:^{
		// Use when fetching text data
		NSString *responseString = [formRequest responseString];
		int statusCode = [formRequest responseStatusCode];
		LOG_EXPR(statusCode);
		LOG_EXPR(responseString);
		
		if (statusCode == 200) {
//			waitLabel.text = @":D";
			[hud setCaption:@"Done!"];
		} else {
//			waitLabel.text = @":(";
			[hud setCaption:@"A network error occured"];
		}
		
		[hud setProgress:1.0];
		
		[UIView animateWithDuration:0.3 delay:1 options:0 animations:^(void) {
			hud.view.alpha = 0;
			darkView.alpha = 0;
		} completion:^(BOOL finished) {
			if (self.delegate && [self.delegate respondsToSelector:@selector(CamPreview:didSucceedUploadingIndex:)]) {
				[self.delegate CamPreview:self didSucceedUploadingIndex:selectedIndex];
			}
			
			[darkView removeFromSuperview];
			[darkView release];
			
//			[waitView removeFromSuperview];
			[hud.view removeFromSuperview];
			[hud release];
            
            AudioServicesPlaySystemSound(uploadCompleteSound);
            
			[self back:self];
		}];
	}];
	
	[formRequest setFailedBlock:^{
		NSError *error = [formRequest error];
		NSLog(@"error: %@", error);
		
		[hud setCaption:@"A network error occured"];
        
        [[[[UIAlertView alloc] initWithTitle:@"Upload Failed" message:@"Your internet connection is weak. Have another beer, move around and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
		
//		waitLabel.text = @":(";
		[UIView animateWithDuration:0.3 delay:1 options:0 animations:^(void) {
			hud.view.alpha = 0;
			darkView.alpha = 0;
		} completion:^(BOOL finished) {
			if (self.delegate && [self.delegate respondsToSelector:@selector(CamPreview:didFailUploadingIndex:)]) {
				[self.delegate CamPreview:self didFailUploadingIndex:selectedIndex];
			}
			
			[darkView removeFromSuperview];
			[darkView release];
			
//			[waitView removeFromSuperview];
			[hud.view removeFromSuperview];
			[hud release];
//			[self back:self];
		}];
	}];
	
	[formRequest startAsynchronous];
	
//	[waitView release];
//	[waitLabel release];
}


#pragma mark delegate methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.nearLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tmptableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	if (!(cell = [tmptableView dequeueReusableCellWithIdentifier:@"cellID"])) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"] autorelease];
	}
	
	cell.textLabel.text = [[self.nearLocations objectAtIndex:indexPath.row] name];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.locationTextField.text = [NSString stringWithFormat:@"%@, Roskilde Festival", [[self.nearLocations objectAtIndex:indexPath.row] name]];
	
	[UIView animateWithDuration:0.3 animations:^(void) {
		self.tableView.frame = CGRectOffset(self.tableView.frame, 0, -(self.view.frame.size.height - self.uploadView.frame.size.height));
	} completion:^(BOOL finished) {
		[self.tableView removeFromSuperview];
		self.tableView = nil;
	}];
}


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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if ([string isEqualToString:@"\n"]) {
		[textField resignFirstResponder];
		self.locationButton.hidden = NO;
		return NO;
	}
	
	if ([[textField.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:@""]) {
		self.locationButton.hidden = NO;
	} else {
		self.locationButton.hidden = YES;
	}
	
	return YES;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField {
	self.locationButton.hidden = NO;
	return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
	if (![textField.text isEqualToString:@""]) {
		self.locationButton.hidden = YES;
	}
	
	if (self.tableView) {
		[UIView animateWithDuration:0.3 animations:^(void) {
			self.tableView.frame = CGRectOffset(self.tableView.frame, 0, -(self.view.frame.size.height - self.uploadView.frame.size.height));
		} completion:^(BOOL finished) {
			[self.tableView removeFromSuperview];
			self.tableView = nil;
		}];
	}
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if (self.currentLocation != nil) {
		return;
	}
	
	self.currentLocation = newLocation;
	
	[self.locationManager stopUpdatingLocation];
	
	RFLocation *nearestLocation = nil;
	self.nearLocations = [LocationManager locationObjectsForPosition:newLocation.coordinate nearest:&nearestLocation];
	
	if (self.nearLocations == nil || [self.nearLocations count] == 0) {
		self.reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
		self.reverseGeocoder.delegate = self;
		[self.reverseGeocoder start];
	} else {
		self.locationButton.hidden = YES;
		
		if ([self.locationTextField.text isEqualToString:@""]) {
			for (RFLocation *l in self.nearLocations) {
				if ([l.type isEqualToString:@"stage"]) {
					nearestLocation = l;
					break;
				}
			}
			
			self.locationTextField.text = [NSString stringWithFormat:@"%@, Roskilde Festival", nearestLocation.name];
		}
	}
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	if ([self.locationTextField.text isEqualToString:@""]) {
		if (placemark.locality) {
			self.locationTextField.text = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.countryCode];
		}
	}
	
	self.reverseGeocoder = nil;
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	self.reverseGeocoder = nil;
}


- (void)dealloc {
	[descriptionPlaceholder release];
	[description release];
	[locationTextField release];
	[scrollView release];
	[pageControl release];
	[pageControl release];
	[locationButton release];
	self.replyTo = nil;
	[super dealloc];
}

@end
