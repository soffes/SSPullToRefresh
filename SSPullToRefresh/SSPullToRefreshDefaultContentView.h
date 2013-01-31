//
//  SSPullToRefreshDefaultContentView
//  SSPullToRefresh
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

#import "SSPullToRefreshView.h"

@interface SSPullToRefreshDefaultContentView : UIView <SSPullToRefreshContentView>

@property (nonatomic, strong, readonly) UILabel *statusLabel;
@property (nonatomic, strong, readonly) UILabel *lastUpdatedAtLabel;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicatorView;

@end
