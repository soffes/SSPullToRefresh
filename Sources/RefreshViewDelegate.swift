//
//  RefreshViewDelegate.swift
//  PullToRefresh
//
//  Created by Sam Soffes on 6/29/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import UIKit

public protocol RefreshViewDelegate: class {
	/// Return `false` if the refresh view should not start loading.
	func refreshViewshouldStartLoading(refreshView: RefreshView) -> Bool
	
	/// The refresh view started loading. You should kick off whatever you need to load when this is called.
	func refreshViewDidStartLoading(refreshView: RefreshView)
	
	/// The refresh view finished loading. This will get called when it receives `finishLoading`.
	func refreshViewDidFinishLoading(refreshView: RefreshView)
	
	/// The date when data was last updated. This will get called when it finishes loading or if it receives
	/// `invalidateLastUpdatedAt`. Some content views may display this date.
	func lastUpdatedAtForRefreshView(refreshView: RefreshView) -> NSDate?
	
	/// The refresh view updated its scroll view's content inset.
	func refreshView(refreshView: RefreshView, didUpdateContentInset contentInset: UIEdgeInsets)
	
	/// The refresh view will change state.
	func refreshView(refreshView: RefreshView, willTransitionTo to: RefreshView.State, from: RefreshView.State, animated: Bool)
	
	/// The refresh view did change state.
	func refreshView(refreshView: RefreshView, didTransitionTo to: RefreshView.State, from: RefreshView.State, animated: Bool)
}
