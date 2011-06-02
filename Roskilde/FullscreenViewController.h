//
//  FullscreenViewController.h
//  Roskilde
//
//  Created by Ulrik Damm on 6/1/11.
//  Copyright 2011 Gereen.dk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFPictureDetailTableViewController.h"

@interface FullscreenViewController : UIViewController {
	id <RFPictureDetailTableViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id <RFPictureDetailTableViewControllerDelegate> delegate;



- (void)fullscreen;

@end
