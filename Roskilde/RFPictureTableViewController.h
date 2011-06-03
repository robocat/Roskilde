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
}

@property (nonatomic, retain) NSMutableArray *entries;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;


@end
