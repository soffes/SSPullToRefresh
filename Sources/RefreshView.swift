//
//  RefreshView.swift
//  PullToRefresh
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright © 2012-2016 Sam Soffes. All rights reserved.
//

import UIKit

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
	
	/// The delegate is sent messages when the refresh view starts loading. This is automatically set with
	/// `init(scrollView:delegate:)`.
	public weak var delegate: RefreshViewDelegate?
	
	/// The scroll view containing the refresh view. This is automatically set with `init(scrollView:delegate:)`.
	public weak var scrollView: UIScrollView?
	
	/// The content view displayed when the `scrollView` is pulled down.
	public let contentView: ContentView
	
	public private(set) var state: State = .Closed
	
	/// If you need to update the scroll view's content inset while it contains a refresh view, you should set the
	/// `defaultContentInset` on the refresh view and it will forward it to the scroll view taking into account the
	/// refresh view's position.
	public var defaultContentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	
	/// The height of the fully expanded content view. The default is `64.0`.
	///
	/// The `contentView`'s `sizeThatFits:` will be respected when displayed but does not effect the expanded height.
	/// You can use this to draw outside of the expanded area. If you don't implement `sizeThatFits:` it will
	/// automatically display at the default size.
	public var expandedHeight: CGFloat = 64
	
	/// A boolean indicating if the pull to refresh view is expanded.
	public var isExpanded: Bool {
		return false
	}


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
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/// Call this method when you start loading. If you trigger loading another way besides pulling to refresh, call
	/// this method so the receiver will be in sync with the loading status. By default, it will not expand the view so
	/// it loads quietly out of view.
	public func startLoading(expand: Bool = false, animated: Bool = true, completion: (() -> Void)? = nil) {
		
	}

	/// Call this when you finish loading.
	public func finishLoading(animated: Bool = true, completion: (() -> Void)? = nil) {
		
	}

	/// Manually update the last updated at time. This will automatically get called when the refresh view finishes
	/// loading.
	public func invalidateLastUpdatedAt() {

	}
}
