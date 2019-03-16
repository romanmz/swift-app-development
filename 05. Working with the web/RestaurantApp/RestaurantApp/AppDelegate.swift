//
//  AppDelegate.swift
//  RestaurantApp
//
//  Created by Román Martínez on 3/14/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	
	// Properties
	// ------------------------------
	var window: UIWindow?
	var tabBar: UITabBarController {
		return self.window!.rootViewController! as! UITabBarController
	}
	var tabViews: [UIViewController] {
		return tabBar.viewControllers!
	}
	
	
	// Lifecycle hooks
	// ------------------------------
	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		MenuData.loadItemsFromFile()
		MenuData.loadOrderFromFile()
		MenuData.fetchMenuItems { items in
			if let items = items {
				MenuData.menuItems = items
			} else {
				DispatchQueue.main.async {
					self.tabBar.selectedViewController?.errorAlert(title: "Network error", message: "There was an error while trying to load the menu items from the server")
				}
			}
		}
		return true
	}
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		setupURLCache()
		setupOrderBadge()
		return true
	}
	func applicationWillResignActive(_ application: UIApplication) {}
	func applicationDidEnterBackground(_ application: UIApplication) {
		MenuData.saveItemsToFile()
		MenuData.saveOrderToFile()
	}
	func applicationWillEnterForeground(_ application: UIApplication) {}
	func applicationDidBecomeActive(_ application: UIApplication) {}
	func applicationWillTerminate(_ application: UIApplication) {}
	
	
	// Setup cache settings
	// ------------------------------
	func setupURLCache() {
		let tempDir = NSTemporaryDirectory()
		let urlCache = URLCache(memoryCapacity: 25_000_000, diskCapacity: 50_000_000, diskPath: tempDir)
		URLCache.shared = urlCache
	}
	
	
	// Manage "Your Order" badge
	// ------------------------------
	var orderTabBarItem: UITabBarItem {
		return tabViews[1].tabBarItem
	}
	func setupOrderBadge() {
		NotificationCenter.default.addObserver(self, selector: #selector(updateOrderBadge), name: MenuData.orderUpdatedNotification, object: nil)
		updateOrderBadge()
	}
	@objc func updateOrderBadge() {
		let count = MenuData.order.menuItems.count
		orderTabBarItem.badgeValue = count == 0 ? nil : "\(count)"
	}
	
	
}
