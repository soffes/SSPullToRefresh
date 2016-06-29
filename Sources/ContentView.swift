//
//  ContentView.swift
//  PullToRefresh
//
//  Created by Sam Soffes on 6/29/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import UIKit

public protocol ContentView: class {
	var state: RefreshView.State { get set }
	var progress: CGFloat { get set }
	var lastUpdatedAt: NSDate? { get set }
	var view: UIView { get }
}


extension ContentView where Self: UIView {
	public var view: UIView {
		return self
	}
}
