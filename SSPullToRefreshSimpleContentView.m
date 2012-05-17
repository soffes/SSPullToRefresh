//
//  SSPullToRefreshSimpleContentView.m
//  SSPullToRefreshView
//
//  Created by Sam Soffes on 5/17/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

#import "SSPullToRefreshSimpleContentView.h"

@implementation SSPullToRefreshSimpleContentView

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.lastUpdatedAtLabel.hidden = YES;
	}
	return self;
}


- (void)layoutSubviews {
	CGSize size = self.bounds.size;
	self.statusLabel.frame = CGRectMake(20.0f, roundf((size.height - 30.0f) / 2.0f), size.width - 40.0f, 30.0f);
	self.activityIndicatorView.frame = CGRectMake(roundf((size.width - 20.0f) / 2.0f), roundf((size.height - 20.0f) / 2.0f), 20.0f, 20.0f);
}


#pragma mark - SSPullToRefreshContentView

- (void)setState:(SSPullToRefreshViewState)state withPullToRefreshView:(SSPullToRefreshView *)view {	
	switch (state) {
		case SSPullToRefreshViewStateReady: {
			self.statusLabel.text = @"Release to refresh";
			[self.activityIndicatorView startAnimating];
			self.activityIndicatorView.alpha = 0.0f;
			break;
		}
			
		case SSPullToRefreshViewStateNormal: {
			self.statusLabel.text = @"Pull down to refresh";
			self.statusLabel.alpha = 1.0f;
			[self.activityIndicatorView stopAnimating];
			self.activityIndicatorView.alpha = 0.0f;
			break;
		}
			
		case SSPullToRefreshViewStateLoading: {
			self.statusLabel.alpha = 0.0f;
			[self.activityIndicatorView startAnimating];
			self.activityIndicatorView.alpha = 1.0f;
			break;
		}
			
		case SSPullToRefreshViewStateClosing: {
			self.statusLabel.text = nil;
			self.activityIndicatorView.alpha = 0.0f;
			break;
		}
	}
}

@end
