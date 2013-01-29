//
//  SSPullToRefreshSimpleContentView.h
//  SSPullToRefresh
//
//  Created by Sam Soffes on 5/17/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPullToRefreshView.h"

@interface SSPullToRefreshSimpleContentView : UIView <SSPullToRefreshContentView>

@property (nonatomic, strong, readonly) UILabel *statusLabel;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicatorView;

@end
