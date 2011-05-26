//
//  RKTableViewCell.h
//  XKamera
//
//  Created by Willi Wu on 20/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RKTableViewCell : UITableViewCell {
	
@protected
	
	UIView *_cellView;
}

- (void)drawContentView:(CGRect)rect;

@end