//
//  ViewController.swift
//  Example
//
//  Created by Sam Soffes on 6/29/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import UIKit
import PullToRefresh

class ViewController: UITableViewController {
	
	// MARK: - Properties
	
	var dates = [NSDate]()
	var refreshView: RefreshView?

	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Pull to Refresh"
		
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		if refreshView == nil {
			refreshView = RefreshView(scrollView: tableView, delegate: self)
			refreshView?.contentView = SimpleContentView()
		}
	}
	
	
	// MARK: - Actions
	
	private func refresh() {
		refreshView?.startRefreshing()
		dates.insert(NSDate(), atIndex: 0)
		tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Top)
		refreshView?.finishRefreshing()
	}
	
	
	// MARK: - UITableViewDataSource
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dates.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell") ?? UITableViewCell()
		cell.textLabel?.text = dates[indexPath.row].description
		cell.selectionStyle = .None
		return cell
	}
}


extension ViewController: RefreshViewDelegate {
	func refreshViewShouldStartRefreshing(refreshView: RefreshView) -> Bool {
		return true
	}

	func refreshViewDidStartRefreshing(refreshView: RefreshView) {
		refresh()
	}

	func lastUpdatedAtForRefreshView(refreshView: RefreshView) -> NSDate? {
		return dates.first
	}

	func refreshViewDidFinishRefreshing(refreshView: RefreshView) {}
	func refreshView(refreshView: RefreshView, didUpdateContentInset contentInset: UIEdgeInsets) {}
	func refreshView(refreshView: RefreshView, willTransitionTo to: RefreshView.State, from: RefreshView.State, animated: Bool) {}
	func refreshView(refreshView: RefreshView, didTransitionTo to: RefreshView.State, from: RefreshView.State, animated: Bool) {}
}
