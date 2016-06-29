//
//  RefreshView.swift
//  PullToRefresh
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright © 2012-2016 Sam Soffes. All rights reserved.
//

import UIKit

/// Example usage:
///
/// var refreshView: RefreshView?
///
/// override func viewDidLayoutSubviews() {
///     super.viewDidLayoutSubviews()
///
///     if refreshView == nil {
///         refreshView = RefreshView(scrollView: tableView, delegate: self)
///     }
/// }
///
/// func refresh() {
///     refreshView?.startRefreshing()
///     // Load data…
///     refreshView?.finishRefreshing()
/// }
///
/// func refreshViewDidStartRefreshing(refreshView: RefreshView) {
///     refresh()
/// }
public class RefreshView: UIView {
	
	// MARK: - Types
	
	public enum State {
		/// Offscreen.
		case Closed
		
		/// The user started pulling. Most will say "Pull to refresh" in this state.
		case Opening
		
		/// The user pulled far enough to cause a refresh. Most will say "Release to refresh" in this state.
		case Ready
		
		/// The view is refreshing.
		case Refreshing
		
		/// The refresh is completed. The view is now animating out.
		case Closing
	}
	
	public enum Style {
		/// The view is attachted to the scroll view and pulls with the scroll view content.
		case Scrolling
		
		/// The view is stationary behind the scroll view content (like the system UIRefreshControl).
		case Stationary
	}
	
	
	// MARK: - Properties
	
	/// The delegate is sent messages when the refresh view starts refreshing. This is automatically set with
	/// `init(scrollView:delegate:)`.
	public weak var delegate: RefreshViewDelegate?
	
	/// The scroll view containing the refresh view. This is automatically set with `init(scrollView:delegate:)`.
	public weak var scrollView: UIScrollView? {
		willSet {
			guard let scrollView = scrollView else { return }
			scrollView.removeObserver(self, forKeyPath: "contentOffset")
		}

		didSet {
			scrollViewDidChange()
		}
	}
	
	/// The content view displayed when the `scrollView` is pulled down.
	public var contentView: ContentView {
		willSet {
			contentView.view.removeFromSuperview()
		}

		didSet {
			contentViewDidChange()
		}
	}

	/// The state of the receiver.
	public private(set) var state: State = .Closed {
		didSet {
			let wasRefreshing = oldValue == .Refreshing

			// Forward to content view
			contentView.state = state

			// Notify delegate
			if wasRefreshing && state != .Refreshing {
				delegate?.refreshViewDidFinishRefreshing(self)
			} else if !wasRefreshing && state == .Refreshing {
				delegate?.refreshViewDidStartRefreshing(self)
			}
		}
	}

	/// A refresh view style. The default is `.Scrolling`.
	public private(set) var style: Style = .Scrolling {
		didSet {
			// TODO: Update constraints
		}
	}
	
	/// If you need to update the scroll view's content inset while it contains a refresh view, you should set the
	/// `defaultContentInset` on the refresh view and it will forward it to the scroll view taking into account the
	/// refresh view's position.
	public var defaultContentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
		didSet {
			updateTopContentInset(topInset)
		}
	}
	
	/// The height of the fully expanded content view. The default is `64.0`.
	///
	/// The `contentView`'s `sizeThatFits:` will be respected when displayed but does not effect the expanded height.
	/// You can use this to draw outside of the expanded area. If you don't implement `sizeThatFits:` it will
	/// automatically display at the default size.
	public var expandedHeight: CGFloat = 64
	
	/// A boolean indicating if the pull to refresh view is expanded.
	public private(set) var isExpanded = false {
		didSet {
			updateTopContentInset(isExpanded ? expandedHeight : 0)
		}
	}

	private var progress: CGFloat = 0 {
		didSet {
			contentView.progress = progress
		}
	}

	private var topInset: CGFloat = 0

	// Semaphore is used to ensure only one animation plays at a time
	private var animationSemaphore: dispatch_semaphore_t = {
		let semaphore = dispatch_semaphore_create(0)
		dispatch_semaphore_signal(semaphore)
		return semaphore
	}()


	// MARK: - Initializers
	
	/// All you need to do to add this view to your scroll view is call this method (passing in the scroll view).
	/// That's it.
	///
	/// You don't have to add it as subview or anything else. You should only initalize with this method and never move
	/// it to another scroll view during its lifetime.
	public init(scrollView: UIScrollView, delegate: RefreshViewDelegate, contentView: ContentView = DefaultContentView()) {
		self.scrollView = scrollView
		self.delegate = delegate
		self.contentView = contentView

		super.init(frame: .zero)

		translatesAutoresizingMaskIntoConstraints = false

		scrollViewDidChange()
		contentViewDidChange()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		scrollView = nil
	}


	// MARK: - UIView

	public override func removeFromSuperview() {
		scrollView = nil
		super.removeFromSuperview()
	}


	// MARK: - Refreshing
	
	/// Call this method when you start refresing. If you trigger refresing another way besides pulling, call this
	/// method so the receiver will be in sync with the refreshing status. By default, it will not expand the view so it
	/// loads quietly out of view.
	public func startRefreshing(expand: Bool = false, animated: Bool = true, completion: (() -> Void)? = nil) {
		// If we're already refreshing, don't do anything.
		if state == .Refreshing {
			return
		}

		// Animate back to the refreshing state
		set(state: .Refreshing, animated: animated, expand: expand, completion: completion)
	}

	/// Call this when you finish refresing.
	public func finishRefreshing(animated: Bool = true, completion: (() -> Void)? = nil) {
		// If we're not refreshing, don't do anything.
		if state != .Refreshing {
			return
		}

		// Animate back to the normal state
		set(state: .Closing, animated: animated, expand: false) { [weak self] in
			self?.state = .Closed
			completion?()
		}

		invalidateLastUpdatedAt()
	}

	/// Manually update the last updated at time. This will automatically get called when the refresh view finishes
	/// refreshing.
	public func invalidateLastUpdatedAt() {
		let date = delegate?.lastUpdatedAtForRefreshView(self) ?? NSDate()
		contentView.lastUpdatedAt = date
	}


	// MARK: - Private

	private func scrollViewDidChange() {
		guard let scrollView = scrollView else { return }
		defaultContentInsets = scrollView.contentInset
		scrollView.addSubview(self)

		NSLayoutConstraint.activateConstraints([
			leadingAnchor.constraintEqualToAnchor(scrollView.leadingAnchor),
			widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor),
			bottomAnchor.constraintEqualToAnchor(scrollView.topAnchor),
			heightAnchor.constraintEqualToConstant(400)
		])

		scrollView.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
	}

	private func contentViewDidChange() {
		contentView.state = state
		contentView.progress = progress
		invalidateLastUpdatedAt()
		addSubview(contentView.view)

		contentView.view.translatesAutoresizingMaskIntoConstraints = false

		// TODO: Updated height contraint with expandedHeight changes
		// TODO: Support stationary style
		NSLayoutConstraint.activateConstraints([
			contentView.view.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
			contentView.view.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
			contentView.view.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
			contentView.view.heightAnchor.constraintGreaterThanOrEqualToConstant(expandedHeight)
		])
	}

	private func updateTopContentInset(topInset: CGFloat) {
		self.topInset = topInset

		// Default to the scroll view's initial content inset
		var insets = defaultContentInsets

		// Add the top inset
		insets.top += topInset

		// Don't set it if that is already the current inset
		guard let scrollView = scrollView else { return }
		if scrollView.contentInset == insets {
			return
		}

		// Update the content inset
		scrollView.contentInset = insets

		// If scroll view is on top, scroll again to the top (needed for scroll views with content > scroll view).
		if scrollView.contentOffset.y <= 0 {
			scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
		}

		// Tell the delegate
		delegate?.refreshView(self, didUpdateContentInset: scrollView.contentInset)
	}

	private func set(state to: State, animated: Bool, expand: Bool, completion: (() -> Void)? = nil) {
		let from = state

		delegate?.refreshView(self, willTransitionTo: to, from: from, animated: animated)

		if !animated {
			state = to
			isExpanded = expand
			completion?()
			delegate?.refreshView(self, didTransitionTo: to, from: from, animated: animated)
			return
		}

		// Go to a background queue to wait for previous animations to finish
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) { [weak self] in
			// Wait for previous animations to finish
			guard let semaphore = self?.animationSemaphore else { return }
			dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)

			// Previous animations are finished. Go back to the main queue.
			dispatch_async(dispatch_get_main_queue()) {
				// Animate the change
				UIView.animateKeyframesWithDuration(0.3, delay: 0, options: .AllowUserInteraction, animations: {
					self?.state = to
					self?.isExpanded = expand
				}, completion: { _ in
					dispatch_semaphore_signal(semaphore)
					completion?()

					if let this = self {
						this.delegate?.refreshView(this, didTransitionTo: to, from: from, animated: animated)
					}
				})
			}
		}
	}


	// MARK: - NSKeyValueObserving

	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		// Call super if we didn't register for this notification
		if keyPath != "contentOffset" {
			super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
			return
		}

		// Get the offset out of the change notification
		guard let offsetY = (change?[NSKeyValueChangeNewKey] as? NSValue)?.CGPointValue().y,
			scrollView = scrollView
		else { return }

		let y = offsetY + defaultContentInsets.top

		// Scroll view is dragging
		if scrollView.dragging {
			// Scroll view is ready
			if state == .Ready {
				// Update the content view's pulling progressing
				progress = -y / expandedHeight

				// Dragged enough to refresh
				if y > -expandedHeight && y < 0 {
					state = .Closed
				}
			}

			// Scroll view is normal
			else if state == .Closed {
				// Update the content view's pulling progressing
				progress = -y / expandedHeight

				// Dragged enough to be ready
				if y < -expandedHeight {
					state = .Ready
				}
			}

			// Scroll view is refreshing
			else if state == .Refreshing {
				let insetAdjustment = y < 0 ? max(0, expandedHeight + y) : expandedHeight
				updateTopContentInset(expandedHeight - insetAdjustment)
			}
			return
		} else if scrollView.decelerating {
			progress = -y / self.expandedHeight
		}

		// If the scroll view isn't ready, we're not interested
		if state != .Ready {
			return
		}

		// We're ready, prepare to switch to refreshing. By default, we should refresh.
		var newState = State.Refreshing

		// Ask the delegate if it's cool to start refreshing
		var expand = true
		if let delegate = delegate where !delegate.refreshViewShouldStartRefreshing(self) {
			// Animate back to normal since the delegate said no
			newState = .Closed
			expand = false
		}

		// Animate to the new state
		set(state: newState, animated: true, expand: expand)
	}
}
