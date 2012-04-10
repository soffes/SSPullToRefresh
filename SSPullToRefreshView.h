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
@protocol SSPullToRefreshViewContentView;

@interface SSPullToRefreshView : UIView

@property (nonatomic, assign, readonly) UIScrollView *scrollView;
@property (nonatomic, assign) id<SSPullToRefreshViewDelegate> delegate;
@property (nonatomic, assign) CGFloat expandedHeight;
@property (nonatomic, strong) UIView<SSPullToRefreshViewContentView> *contentView;

- (id)initWithScrollView:(UIScrollView *)scrollView;

- (void)finishedLoading;
- (void)refreshLastUpdatedAt;

@end


@protocol SSPullToRefreshViewDelegate <NSObject>

@optional

- (BOOL)pullToRefreshViewShouldRefresh:(SSPullToRefreshView *)view;
- (NSDate *)pullToRefreshViewLastUpdatedAt:(SSPullToRefreshView *)view;

@end


@protocol SSPullToRefreshViewContentView <NSObject>

@optional

- (void)setState:(SSPullToRefreshViewState)state withPullToRefreshView:(SSPullToRefreshView *)view;
- (void)setLastUpdatedAt:(NSDate *)date withPullToRefreshView:(SSPullToRefreshView *)view;

@end
