//
//  SSPullToRefreshSimpleContentView.h
//  SSPullToRefresh
//
//  Created by Sam Soffes on 5/17/12.
//  Copyright (c) 2012-2014 Sam Soffes. All rights reserved.
//

#import "SSPullToRefreshView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSPullToRefreshSimpleContentView : UIView <SSPullToRefreshContentView>

@property (nonatomic, readonly) UILabel *statusLabel;
@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicatorView;

@end

NS_ASSUME_NONNULL_END
