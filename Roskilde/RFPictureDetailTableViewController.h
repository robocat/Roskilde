//
//  RFPictureDetailTableViewController.h
//  Roskilde
//
//  Created by Willi Wu on 25/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RFPictureDetailTableViewController : UITableViewController {
    NSDictionary * _entry;
}

@property (nonatomic, retain) NSDictionary *entry;

@end
