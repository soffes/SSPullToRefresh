//
//  DefaultContentView.swift
//  PullToRefresh
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright © 2012-2016 Sam Soffes. All rights reserved.
//

import UIKit

public class DefaultContentView: UIView, ContentView {
	
	// MARK: - Properties
	
	public var state: RefreshView.State = .Closed {
		didSet {
			updateState()
		}
	}
	
	public var progress: CGFloat = 0
	public var lastUpdatedAt: NSDate?
	
	public let statusLabel: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFontOfSize(14)
		label.textColor = .blackColor()
		label.backgroundColor = .clearColor()
		label.textAlignment = .Center
		return label
	}()
	
	public let lastUpdatedAtLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFontOfSize(12)
		label.textColor = .lightGrayColor()
		label.backgroundColor = .clearColor()
		label.textAlignment = .Center
		return label
	}()
	
	public let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
	
	
	// MARK: - Initializers
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(statusLabel)
		addSubview(lastUpdatedAtLabel)
		addSubview(activityIndicatorView)
		
		updateState()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - UIView
	
	public override func layoutSubviews() {
		let width = bounds.width
		
		statusLabel.frame = CGRect(x: 0, y: 14, width: width, height: 20)
		lastUpdatedAtLabel.frame = CGRect(x: 0, y: 34, width: width, height: 20)
		activityIndicatorView.frame = CGRect(x: 30, y: 25, width: 20, height: 20)
	}
	
	
	// MARK: - Private
	
	private func updateState() {
		switch state {
		case .Closed, .Opening:
			statusLabel.text = NSLocalizedString("Pull down to refresh…", comment: "")
			activityIndicatorView.stopAnimating()
		case.Ready:
			statusLabel.text = NSLocalizedString("Release to refresh…", comment: "")
			activityIndicatorView.stopAnimating()
		case .Refreshing, .Closing:
			statusLabel.text = NSLocalizedString("Loading…", comment: "")
			activityIndicatorView.startAnimating()
		}
	}
}
