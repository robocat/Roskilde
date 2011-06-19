//
//  PullToRefreshView.h
//  PullToRefresh
//
//  Created by Scott Rossillo on 4/22/11.
//  Copyright 2011.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@protocol PullToRefreshViewDelegate;

/**
  Provides a pull to refresh view.
 */
@interface PullToRefreshView : UIView {
    
    @private
    id<PullToRefreshViewDelegate> delegate;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
    UITableView *_tableView;
    
    SystemSoundID pullSound;
    SystemSoundID releaseSound;
	BOOL	isPullSoundPlayed;
}

@property (nonatomic, readonly) UITableView *tableView;

@property (nonatomic, readonly) UILabel *refreshLabel;
@property (nonatomic, readonly) UIImageView *refreshArrow;
@property (nonatomic, readonly) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

- (id)initWithTableView:(UITableView *)tableView delegate:(id<PullToRefreshViewDelegate>)delegate;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)startLoading;
- (void)stopLoading;

@end

/**
  Provides a pull to refresh delegate protocol.
 */
@protocol PullToRefreshViewDelegate

/**
  Tells the delegate that a table data refresh was requested.
 
  @param tableView - A table-view object informing the delegate about the request to refresh.
 */
- (void)refreshRequestedForTableView:(UITableView *)tableView;

@end