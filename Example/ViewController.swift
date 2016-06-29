//
//  ViewController.swift
//  Example
//
//  Created by Sam Soffes on 6/29/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	
	// MARK: - Properties
	
	var strings = [String]()
	
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Pull to Refresh"
		
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
	}
	
	
	// MARK: - Actions
	
	private func refresh() {
		strings.insert(NSDate().description, atIndex: 0)
		tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Top)
	}
	
	
	// MARK: - UITableViewDataSource
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return strings.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell") ?? UITableViewCell()
		cell.textLabel?.text = strings[indexPath.row]
		cell.selectionStyle = .None
		return cell
	}
}
