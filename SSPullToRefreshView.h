//
//  SSPullToRefreshView.h
//  SSPullToRefresh
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

//
// Example usage:
// 
// - (void)viewDidLoad {
//    [super viewDidLoad];
//    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
// }
// 
// 
// - (void)refresh {
//    [self.pullToRefreshView startLoading];
//    // Load data...
//    [self.pullToRefreshView finishLoading];
// }
// 
// - (void)pullToRefreshViewShouldRefreshDidStartLoading:(SSPullToRefreshView *)view {
//    [self refresh];
// }
//

#import <UIKit/UIKit.h>

typedef enum {
	SSPullToRefreshViewStateNormal,
	SSPullToRefreshViewStateReady,
	SSPullToRefreshViewStateLoading,
	SSPullToRefreshViewStateClosing
} SSPullToRefreshViewState;

@protocol SSPullToRefreshViewDelegate;
@protocol SSPullToRefreshContentView;

@interface SSPullToRefreshView : UIView

@property (nonatomic, assign, readonly) UIScrollView *scrollView;
@property (nonatomic, assign) id<SSPullToRefreshViewDelegate> delegate;
@property (nonatomic, assign, readonly) SSPullToRefreshViewState state;
@property (nonatomic, assign) CGFloat expandedHeight;
@property (nonatomic, assign, readonly, getter = isExpanded) BOOL expanded;
@property (nonatomic, strong) UIView<SSPullToRefreshContentView> *contentView;

/**
 If you need to update the scroll view's content inset while it contains a pull to refresh view, you should set the
 `defaultContentInset` on the pull to refresh view and it will forward it to the scroll view taking into account the
 pull to refresh view's position.
 */
@property (nonatomic, assign) UIEdgeInsets defaultContentInset;

/**
 All you need to do to add this view to your scroll view is call this method (passing in the scroll view). That's it.
 You don't have to add it as subview or anything else. The rest is magic.
 */
- (id)initWithScrollView:(UIScrollView *)scrollView delegate:(id<SSPullToRefreshViewDelegate>)delegate;

/**
 Call this method when you start loading. If you trigger loading another way besides pulling to refresh, call this
 method so the pull to refresh view will be in sync with the loading status. By default, it will not expand the view
 so it loads quietly out of view.
 */
- (void)startLoading;

/**
 Call this method when you start loading. If you trigger loading another way besides pulling to refresh, call this
 method so the pull to refresh view will be in sync with the loading status. You may pass YES for shouldExpand to
 animate down the pull to refresh view to show that it's loading.
 */
- (void)startLoadingAndExpand:(BOOL)shouldExpand;

/**
 Call this when you finish loading.
 */
- (void)finishedLoading;

- (void)refreshLastUpdatedAt;

@end


@protocol SSPullToRefreshViewDelegate <NSObject>

@optional

- (BOOL)pullToRefreshViewShouldStartLoading:(SSPullToRefreshView *)view;
- (void)pullToRefreshViewShouldRefreshDidStartLoading:(SSPullToRefreshView *)view;
- (void)pullToRefreshViewShouldRefreshDidFinishLoading:(SSPullToRefreshView *)view;
- (NSDate *)pullToRefreshViewLastUpdatedAt:(SSPullToRefreshView *)view;

@end


@protocol SSPullToRefreshContentView <NSObject>

@required

- (void)setState:(SSPullToRefreshViewState)state withPullToRefreshView:(SSPullToRefreshView *)view;

@optional

- (void)setLastUpdatedAt:(NSDate *)date withPullToRefreshView:(SSPullToRefreshView *)view;

@end
