//
//  SSSimplePullToRefreshContentView.h
//  SSPullToRefresh
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPullToRefreshView.h"

@interface SSSimplePullToRefreshContentView : UIView <SSPullToRefreshContentView>

@property (nonatomic, strong, readonly) UILabel *statusLabel;
@property (nonatomic, strong, readonly) UILabel *lastUpdatedAtLabel;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicatorView;

@end
