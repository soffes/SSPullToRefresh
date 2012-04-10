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
	SSPullToRefreshViewStateLoading
} SSPullToRefreshViewState;

@protocol SSPullToRefreshViewDelegate;
@protocol SSPullToRefreshContentView;

@interface SSPullToRefreshView : UIView

@property (nonatomic, assign, readonly) UIScrollView *scrollView;
@property (nonatomic, assign) id<SSPullToRefreshViewDelegate> delegate;
@property (nonatomic, assign) CGFloat expandedHeight;
@property (nonatomic, strong) UIView<SSPullToRefreshContentView> *contentView;

- (id)initWithScrollView:(UIScrollView *)scrollView;

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
