//
//  RFPictureTableViewController.h
//  Roskilde
//
//  Created by Willi Wu on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRefreshTableViewController.h"


@interface RFPictureTableViewController : BaseRefreshTableViewController {
	NSMutableArray *_entries;
	
	NSInteger loadedCount;
	UIActivityIndicatorView *spinner;
	
	BOOL showMyPictures;
	UIImageView *xbg;
}

@property (nonatomic, retain) NSMutableArray *entries;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, assign, getter=isShowMyPictures) BOOL showMyPictures;
@property (nonatomic, retain) IBOutlet UIImageView *xbg;

@end
