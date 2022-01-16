//
//  MainTabsViewController.swift
//  Renter
//
//  Created by Oleg Efimov on 16.01.2022.
//

import UIKit

class MainTabsViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self

        let historyTab = HistoryViewController()
        let historyIcon = UITabBarItem(
            title: "History",
            image: UIImage(systemName: "chart.line.uptrend.xyaxis"),
            tag: 0)
        historyTab.tabBarItem = historyIcon
        let accountTab = AccountViewController()
        let accountIcon = UITabBarItem(
            title: "Account",
            image: UIImage(systemName: "person.crop.circle"),
            tag: 1)
        accountTab.tabBarItem = accountIcon
        
        viewControllers = [historyTab, accountTab]
    }

}


extension MainTabsViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select \(viewController.title ?? "")")
        return true
    }
}
