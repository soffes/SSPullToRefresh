//
//  SSPullToRefreshDefaultContentView
//  SSPullToRefresh
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright (c) 2012-2014 Sam Soffes. All rights reserved.
//

#import "SSPullToRefreshView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSPullToRefreshDefaultContentView : UIView <SSPullToRefreshContentView>

@property (nonatomic, readonly) UILabel *statusLabel;
@property (nonatomic, readonly) UILabel *lastUpdatedAtLabel;
@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicatorView;

@end

NS_ASSUME_NONNULL_END
