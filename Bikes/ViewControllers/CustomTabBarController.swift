//
//  CustomTabBarController.swift
//  Bikes
//
//  Created by Andy Geipel on 12/19/20.
//

import Foundation


import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarAnimation(viewControllers: tabBarController.viewControllers)
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        
        // MARK: - Set tab bar rounding
        delegate = self
        //Make tab bar rounded and change background
        self.tabBar.layer.masksToBounds = true
        self.tabBar.isTranslucent = true
        self.tabBar.barStyle = .black
        self.tabBar.alpha = 0.8
        self.tabBar.layer.cornerRadius = 14
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.insetsLayoutMarginsFromSafeArea = true
    }
    
}


