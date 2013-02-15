//
//  SSPullToRefreshView.m
//  SSPullToRefresh
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

#import "SSPullToRefreshView.h"
#import "SSPullToRefreshDefaultContentView.h"

@interface SSPullToRefreshView ()
@property (nonatomic, assign, readwrite) SSPullToRefreshViewState state;
@property (nonatomic, assign, readwrite) UIScrollView *scrollView;
@property (nonatomic, assign, readwrite, getter = isExpanded) BOOL expanded;
- (void)_setContentInsetTop:(CGFloat)topInset;
- (void)_setState:(SSPullToRefreshViewState)state animated:(BOOL)animated expanded:(BOOL)expanded completion:(void (^)(void))completion;
- (void)_setPullProgress:(CGFloat)pullProgress;
@end

@implementation SSPullToRefreshView {
	dispatch_semaphore_t _animationSemaphore;
	CGFloat _topInset;
}

@synthesize delegate = _delegate;
@synthesize scrollView = _scrollView;
@synthesize expandedHeight = _expandedHeight;
@synthesize contentView = _contentView;
@synthesize state = _state;
@synthesize expanded = _expanded;
@synthesize defaultContentInset = _defaultContentInset;


#pragma mark - Accessors

- (void)setState:(SSPullToRefreshViewState)state {
	BOOL wasLoading = _state == SSPullToRefreshViewStateLoading;
    _state = state;
	
	// Forward to content view
	[self.contentView setState:_state withPullToRefreshView:self];
	
	// Update delegate
	if (wasLoading && _state != SSPullToRefreshViewStateLoading) {
		if ([_delegate respondsToSelector:@selector(pullToRefreshViewDidFinishLoading:)]) {
			[_delegate pullToRefreshViewDidFinishLoading:self];
		}
	} else if (!wasLoading && _state == SSPullToRefreshViewStateLoading) {
		[self _setPullProgress:1.0f];
		if ([_delegate respondsToSelector:@selector(pullToRefreshViewDidStartLoading:)]) {
			[_delegate pullToRefreshViewDidStartLoading:self];
		}
	}
}


- (void)setExpanded:(BOOL)expanded {
	_expanded = expanded;
	[self _setContentInsetTop:expanded ? self.expandedHeight : 0.0f];
}


- (void)setScrollView:(UIScrollView *)scrollView {
	void *context = (__bridge void *)self;
	if ([_scrollView respondsToSelector:@selector(removeObserver:forKeyPath:context:)]) {
		[_scrollView removeObserver:self forKeyPath:@"contentOffset" context:context];
	} else if (_scrollView) {
		[_scrollView removeObserver:self forKeyPath:@"contentOffset"];
	}
	
	_scrollView = scrollView;	
	_defaultContentInset = _scrollView.contentInset;
	[_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
}


- (UIView<SSPullToRefreshContentView> *)contentView {
	// Use the simple content view as the default
	if (!_contentView) {
		self.contentView = [[SSPullToRefreshDefaultContentView alloc] initWithFrame:CGRectZero];
	}
	return _contentView;
}


- (void)setContentView:(UIView<SSPullToRefreshContentView> *)contentView {
	[_contentView removeFromSuperview];
	_contentView = contentView;
	
	_contentView.autoresizingMask = UIViewAutoresizingNone;
	[_contentView setState:_state withPullToRefreshView:self];
	[self refreshLastUpdatedAt];
	[self addSubview:_contentView];
}


- (void)setDefaultContentInset:(UIEdgeInsets)defaultContentInset {
	_defaultContentInset = defaultContentInset;
	[self _setContentInsetTop:_topInset];
}


#pragma mark - NSObject

- (void)dealloc {
	self.scrollView = nil;
	self.delegate = nil;
#if !OS_OBJECT_USE_OBJC
	dispatch_release(_animationSemaphore);
#endif
}


#pragma mark - UIView

- (void)removeFromSuperview {
	self.scrollView = nil;
	[super removeFromSuperview];
}


- (void)layoutSubviews {
	CGSize size = self.bounds.size;
	CGSize contentSize = [self.contentView sizeThatFits:size];

	if (contentSize.width < size.width) {
		contentSize.width = size.width;
	}

	if (contentSize.height < _expandedHeight) {
		contentSize.height = _expandedHeight;
	}

	self.contentView.frame = CGRectMake(roundf((size.width - contentSize.width) / 2.0f), size.height - contentSize.height, contentSize.width, contentSize.height);
}


#pragma mark - Initializer

- (id)initWithScrollView:(UIScrollView *)scrollView delegate:(id<SSPullToRefreshViewDelegate>)delegate {
	CGRect frame = CGRectMake(0.0f, 0.0f - scrollView.bounds.size.height, scrollView.bounds.size.width,
							  scrollView.bounds.size.height);
	if ((self = [self initWithFrame:frame])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.scrollView = scrollView;
		self.delegate = delegate;
		self.state = SSPullToRefreshViewStateNormal;
		self.expandedHeight = 70.0f;

		for (UIView *view in self.scrollView.subviews) {
			if ([view isKindOfClass:[SSPullToRefreshView class]]) {
				[[NSException exceptionWithName:@"SSPullToRefreshViewAlreadyAdded" reason:@"There is already a SSPullToRefreshView added to this scroll view. Unexpected things will happen. Don't do this." userInfo:nil] raise];
			}
		}

		// Add to scroll view
		[self.scrollView addSubview:self];

		// Semaphore is used to ensure only one animation plays at a time
		_animationSemaphore = dispatch_semaphore_create(0);
		dispatch_semaphore_signal(_animationSemaphore);
	}
	return self;
}


#pragma mark - Loading

- (void)startLoading {
	[self startLoadingAndExpand:NO animated:NO];
}


- (void)startLoadingAndExpand:(BOOL)shouldExpand {
	[self startLoadingAndExpand:shouldExpand animated:YES];
}


- (void)startLoadingAndExpand:(BOOL)shouldExpand animated:(BOOL)animated {
	// If we're not loading, this method has no effect
    if (_state == SSPullToRefreshViewStateLoading) {
		return;
	}

	// Animate back to the loading state
	[self _setState:SSPullToRefreshViewStateLoading animated:animated expanded:shouldExpand completion:nil];
}


- (void)finishLoading {
	// If we're not loading, this method has no effect
    if (_state != SSPullToRefreshViewStateLoading) {
		return;
	}
	
	// Animate back to the normal state
	__weak SSPullToRefreshView *blockSelf = self;
	[self _setState:SSPullToRefreshViewStateClosing animated:YES expanded:NO completion:^{
		blockSelf.state = SSPullToRefreshViewStateNormal;
	}];
	[self refreshLastUpdatedAt];
}


- (void)refreshLastUpdatedAt {
	NSDate *date = nil;
	if ([_delegate respondsToSelector:@selector(pullToRefreshViewLastUpdatedAt:)]) {
		date = [_delegate pullToRefreshViewLastUpdatedAt:self];
	} else {
		date = [NSDate date];
	}
	
	// Forward to content view
	if ([self.contentView respondsToSelector:@selector(setLastUpdatedAt:withPullToRefreshView:)]) {
		[self.contentView setLastUpdatedAt:date withPullToRefreshView:self];
	}
}


#pragma mark - Private

- (void)_setContentInsetTop:(CGFloat)topInset {
	_topInset = topInset;
	
	// Default to the scroll view's initial content inset
	UIEdgeInsets inset = _defaultContentInset;
	
	// Add the top inset
	inset.top += _topInset;
	
	// Don't set it if that is already the current inset
	if (UIEdgeInsetsEqualToEdgeInsets(_scrollView.contentInset, inset)) {
		return;
	}
	
	// Update the content inset
	_scrollView.contentInset = inset;

	// If scrollView is on top, scroll again to the top (needed for scrollViews with content > scrollView).
	if (_scrollView.contentOffset.y == 0) {
		[_scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
	}

	// Tell the delegate
	if ([self.delegate respondsToSelector:@selector(pullToRefreshView:didUpdateContentInset:)]) {
		[self.delegate pullToRefreshView:self didUpdateContentInset:_scrollView.contentInset];
	}
}


- (void)_setState:(SSPullToRefreshViewState)state animated:(BOOL)animated expanded:(BOOL)expanded completion:(void (^)(void))completion {
	if (!animated) {
		self.state = state;
		self.expanded = expanded;
		
		if (completion) {
			completion();
		}
		return;
	}
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		dispatch_semaphore_wait(_animationSemaphore, DISPATCH_TIME_FOREVER);
		dispatch_async(dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
				self.state = state;
				self.expanded = expanded;
			} completion:^(BOOL finished) {
				dispatch_semaphore_signal(_animationSemaphore);
				if (completion) {
					completion();
				}
			}];
		});
	});
}


- (void)_setPullProgress:(CGFloat)pullProgress {
	if ([self.contentView respondsToSelector:@selector(setPullProgress:)]) {
		[self.contentView setPullProgress:pullProgress];
	}
}


#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	// Call super if we didn't register for this notification
	if (context != (__bridge void *)self) {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		return;
	}
	
	// We don't care about this notificaiton
	if (object != _scrollView || ![keyPath isEqualToString:@"contentOffset"]) {
		return;
	}
	
	// Get the offset out of the change notification
	CGFloat y = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y + _defaultContentInset.top;

	// Scroll view is dragging
	if (_scrollView.isDragging) {
		// Scroll view is ready
		if (_state == SSPullToRefreshViewStateReady) {
			// Dragged enough to refresh
			if (y > -_expandedHeight && y < 0.0f) {
				self.state = SSPullToRefreshViewStateNormal;
			}
		// Scroll view is normal
		} else if (_state == SSPullToRefreshViewStateNormal) {
			// Update the content view's pulling progressing
			[self _setPullProgress:-y / _expandedHeight];
			
			// Dragged enough to be ready
			if (y < -_expandedHeight) {
				self.state = SSPullToRefreshViewStateReady;
			}
		// Scroll view is loading
		} else if (_state == SSPullToRefreshViewStateLoading) {
			[self _setContentInsetTop:_expandedHeight];
		}
		return;
	}
	
	// If the scroll view isn't ready, we're not interested
	if (_state != SSPullToRefreshViewStateReady) {
		return;
	}
	
	// We're ready, prepare to switch to loading. Be default, we should refresh.
	SSPullToRefreshViewState newState = SSPullToRefreshViewStateLoading;
	
	// Ask the delegate if it's cool to start loading
	BOOL expand = YES;
	if ([_delegate respondsToSelector:@selector(pullToRefreshViewShouldStartLoading:)]) {
		if (![_delegate pullToRefreshViewShouldStartLoading:self]) {
			// Animate back to normal since the delegate said no
			newState = SSPullToRefreshViewStateNormal;
			expand = NO;
		}
	}
	
	// Animate to the new state
	[self _setState:newState animated:YES expanded:expand completion:nil];
}

@end
