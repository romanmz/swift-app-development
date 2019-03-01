//
//  AppDelegate.swift
//  Restaurant
//
//  Created by Roman Martinez on 28/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	
	// Properties
	// ------------------------------
	var window: UIWindow?
	var orderTabBarItem: UITabBarItem!
	
	
	// Methods
	// ------------------------------
	@objc func updateOrderBadge() {
		let count = MenuController.shared.order.menuItems.count
		if count == 0 {
			orderTabBarItem.badgeValue = nil
		} else {
			orderTabBarItem.badgeValue = String(count)
		}
	}
	
	
	// Hooks
	// ------------------------------
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		// Setup cache
		let tempDir = NSTemporaryDirectory()
		let urlCache = URLCache(memoryCapacity: 25_000_000, diskCapacity: 50_000_000, diskPath: tempDir)
		URLCache.shared = urlCache
		
		// Badge Notifications
		orderTabBarItem = (self.window!.rootViewController! as! UITabBarController).viewControllers![1].tabBarItem
		NotificationCenter.default.addObserver(self, selector: #selector(updateOrderBadge), name: MenuController.orderUpdatedNotification, object: nil)
		
		return true
	}
	func applicationWillResignActive(_ application: UIApplication) {}
	func applicationDidEnterBackground(_ application: UIApplication) {}
	func applicationWillEnterForeground(_ application: UIApplication) {}
	func applicationDidBecomeActive(_ application: UIApplication) {}
	func applicationWillTerminate(_ application: UIApplication) {}
}
