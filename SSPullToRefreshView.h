//
//  SSPullToRefreshView.h
//  SSPullToRefresh
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
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

- (id)initWithScrollView:(UIScrollView *)scrollView delegate:(id<SSPullToRefreshViewDelegate>)delegate;

- (void)startLoading;
- (void)startLoadingAndExpand:(BOOL)shouldExpand;
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
