//
//  ZoomingViewController.h
//  Robokit
//

#import <UIKit/UIKit.h>

@interface ZoomingViewController : NSObject
{
	UIView *view;
	UIView *proxyView;
	UITapGestureRecognizer *singleTapGestureRecognizer;
}

@property (nonatomic, retain, readonly) UIView *proxyView;
@property (nonatomic, retain) UIView *view;

- (void)dismissFullscreenView;

@end
