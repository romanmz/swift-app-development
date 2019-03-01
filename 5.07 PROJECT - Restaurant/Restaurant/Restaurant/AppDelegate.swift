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
	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		MenuController.shared.loadOrder()
		MenuController.shared.loadItems()
		MenuController.shared.fetchMenu()
		return true
	}
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		// Setup cache
		let tempDir = NSTemporaryDirectory()
		let urlCache = URLCache(memoryCapacity: 25_000_000, diskCapacity: 50_000_000, diskPath: tempDir)
		URLCache.shared = urlCache
		
		// Badge Notifications
		orderTabBarItem = (self.window!.rootViewController! as! UITabBarController).viewControllers![1].tabBarItem
		NotificationCenter.default.addObserver(self, selector: #selector(updateOrderBadge), name: MenuController.orderUpdatedNotification, object: nil)
		updateOrderBadge()
		
		return true
	}
	func applicationWillResignActive(_ application: UIApplication) {}
	func applicationDidEnterBackground(_ application: UIApplication) {
        MenuController.shared.saveOrder()
		MenuController.shared.saveItems()
    }
	func applicationWillEnterForeground(_ application: UIApplication) {}
	func applicationDidBecomeActive(_ application: UIApplication) {}
	func applicationWillTerminate(_ application: UIApplication) {}
	
	
	// Enable state restoration
	// you need to manually add "restoration identifiers" to each controller where you want to save user state
	func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
		return true
	}
	func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
		return true
	}
}
