//
//  RFVIewProfileViewController.m
//  Roskilde
//
//  Created by Willi Wu on 19/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFVIewProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SVWebViewController.h"
#import "FLImageView.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "JSONKit.h"



@implementation RFVIewProfileViewController
@synthesize imageView;
@synthesize nameLabel;
@synthesize profileLabel;
@synthesize profileButton;
@synthesize imagesCountLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[profileLabel release];
	[nameLabel release];
	[imageView release];
	[profileButton release];
	[imagesCountLabel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.title = @"My Profile";
	
	UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStyleBordered target:self action:@selector(loggout:)];
	self.navigationItem.rightBarButtonItem = createButton;
	[createButton release];
	
	self.nameLabel.text = [RFGlobal username];
	self.profileLabel.text = [NSString stringWithFormat:@"http://x.dk/%@", [RFGlobal username]];
	profileButton.layer.cornerRadius = 8;
	
	[self performSelector:@selector(fetchUser) withObject:nil afterDelay:0.0];
}

- (void)viewDidUnload
{
	[self setProfileLabel:nil];
	[self setNameLabel:nil];
	[self setImageView:nil];
	[self setProfileButton:nil];
	[self setImagesCountLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)profileButtonPressed:(id)sender {
	NSString *profileUrl = [NSString stringWithFormat:@"http://www.x.dk/%@", [RFGlobal username]];
	SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:profileUrl];
	[self.navigationController pushViewController:webViewController animated:YES];
	[webViewController release];
}


- (void)fetchUser {
	NSString *urlString = [NSString stringWithFormat:@"%@/users/%@", kXdkAPIBaseUrl, [RFGlobal username]];
	NSURL *url = [NSURL URLWithString:urlString];
	__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    // Disabling secure certificate validation
    [request setValidatesSecureCertificate:NO];
    
	[request setDownloadCache:[ASIDownloadCache sharedCache]];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	[request setSecondsToCache:3600];
	
	[request setCompletionBlock:^{
		// Use when fetching text data
		NSString *responseString = [request responseString];
		
		// JSONKit parse
		id parsedData = [responseString objectFromJSONString];
		
		if (parsedData) {
			self.nameLabel.text = [parsedData objectForKey:@"fullname"];
			self.imagesCountLabel.text = [NSString stringWithFormat:@"%d", [[parsedData objectForKey:@"images_count"] intValue]];
			NSString *avatarUrl = [parsedData objectForKey:@"avatar_url"];
			NSString *urlString = [NSString stringWithFormat:@"%@=s100-c", avatarUrl];
			UIImage * placeholder = [UIImage imageNamed:@"avatar100.png"];
			[self.imageView loadImageAtURLString:urlString placeholderImage:placeholder];
		}
	}];
	[request setFailedBlock:^{
		NSError *error = [request error];
		NSLog(@"error: %@", error);
	}];
	[request startAsynchronous];
}

- (void)loggedOut {
	[[NSNotificationCenter defaultCenter] postNotificationName:kUserLoggedIn object:nil];
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)loggout:(id)sender {
	[RFGlobal saveUsername:nil password:nil];
	[self performSelector:@selector(loggedOut) withObject:nil afterDelay:0.1];
}


@end
