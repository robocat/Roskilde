//
//  BaseRefreshViewController.h
//  Roskilde
//
//  Created by Willi Wu on 01/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"


@interface BaseRefreshViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PullToRefreshViewDelegate> {
	UITableView *_tableView;
	PullToRefreshView *_pullToRefreshView;
}

@property (nonatomic, readonly) UITableView *tableView;

- (void)setWhiteTitle:(NSString *)title;

@end
