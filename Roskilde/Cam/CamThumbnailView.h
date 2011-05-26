//
//  CamThumbnailView.h
//  Cam
//
//  Created by Ulrik Damm on 28/4/11.
//  Copyright 2011 ITU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CamThumbnailViewDelegate <NSObject>

- (void)ThumbnailViewThumbnailPressed:(NSUInteger)index;

@end


@interface CamThumbnailView : UIView {
	id<CamThumbnailViewDelegate> thumbnailDelegate;
    NSMutableArray *thumbnails;
}

@property (nonatomic, assign) id<CamThumbnailViewDelegate> thumbnailDelegate;
@property (nonatomic, readonly) NSArray *allThumbnails;

- (void)addThumbnail:(UIImage*)thumbnail;

@end
