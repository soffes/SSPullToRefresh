//
//  SimpleContentView.swift
//  PullToRefresh
//
//  Created by Sam Soffes on 5/17/12.
//  Copyright © 2012-2016 Sam Soffes. All rights reserved.
//

import UIKit

public class SimpleContentView: UIView, ContentView {

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

	public let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)


	// MARK: - Initializers

	public override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(statusLabel)
		addSubview(activityIndicatorView)

		updateState()
	}

	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - UIView

	public override func layoutSubviews() {
		let size = bounds.size

		statusLabel.frame = CGRect(x: 20, y: round((size.height - 30) / 2.0), width: size.width - 40, height: 30)
		activityIndicatorView.frame = CGRect(x: round((size.width - 20) / 2), y: round((size.height - 20) / 2), width: 20, height: 20)
	}


	// MARK: - Private

	private func updateState() {
		switch state {
		case .Closed, .Opening:
			statusLabel.text = NSLocalizedString("Pull down to refresh…", comment: "")
			statusLabel.alpha = 1
			activityIndicatorView.stopAnimating()
			activityIndicatorView.alpha = 0
		case.Ready:
			statusLabel.text = NSLocalizedString("Release to refresh…", comment: "")
			statusLabel.alpha = 1
			activityIndicatorView.stopAnimating()
			activityIndicatorView.alpha = 0
		case .Refreshing:
			statusLabel.alpha = 0
			activityIndicatorView.startAnimating()
			activityIndicatorView.alpha = 1
		case .Closing:
			statusLabel.text = nil
			activityIndicatorView.alpha = 0
		}
	}
}

