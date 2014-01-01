//
//  SSPullToRefreshSimpleContentView.m
//  SSPullToRefresh
//
//  Created by Sam Soffes on 5/17/12.
//  Copyright (c) 2012-2014 Sam Soffes. All rights reserved.
//

#import "SSPullToRefreshSimpleContentView.h"

@implementation SSPullToRefreshSimpleContentView

@synthesize statusLabel = _statusLabel;
@synthesize activityIndicatorView = _activityIndicatorView;


#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		CGFloat width = self.bounds.size.width;

		_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 14.0f, width, 20.0f)];
		_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_statusLabel.font = [UIFont boldSystemFontOfSize:14.0f];
		_statusLabel.textColor = [UIColor blackColor];
		_statusLabel.backgroundColor = [UIColor clearColor];
		_statusLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_statusLabel];

		_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityIndicatorView.frame = CGRectMake(30.0f, 25.0f, 20.0f, 20.0f);
		[self addSubview:_activityIndicatorView];
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
			self.statusLabel.text = NSLocalizedString(@"Release to refresh", nil);
			[self.activityIndicatorView startAnimating];
			self.activityIndicatorView.alpha = 0.0f;
			break;
		}

		case SSPullToRefreshViewStateNormal: {
			self.statusLabel.text = NSLocalizedString(@"Pull down to refresh", nil);
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
