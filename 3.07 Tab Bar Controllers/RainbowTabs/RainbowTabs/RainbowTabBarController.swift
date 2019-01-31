//
//  RainbowTabBarController.swift
//  RainbowTabs
//
//  Created by Roman Martinez on 21/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class RainbowTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		guard let views = self.viewControllers else { return }
		
		var newViews = [UIViewController]()
		for view in views {
			switch view {
				case is YellowViewController, is RedViewController, is GreenViewController:
					view.tabBarItem.badgeValue = "!!!"
					newViews.append(view)
				default:
					break
			}
		}
		self.setViewControllers(newViews, animated: true)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
