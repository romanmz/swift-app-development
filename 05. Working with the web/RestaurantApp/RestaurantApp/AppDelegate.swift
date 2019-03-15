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
		setupOrderBadge()
		return true
	}
	
	
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
