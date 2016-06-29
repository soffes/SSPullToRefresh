//
//  AppDelegate.swift
//  Example
//
//  Created by Sam Soffes on 6/29/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import UIKit

@UIApplicationMain final class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow? = {
		let window = UIWindow()
		window.rootViewController = UINavigationController(rootViewController: ViewController())
		return window
	}()

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		window?.makeKeyAndVisible()
		return true
	}
}
