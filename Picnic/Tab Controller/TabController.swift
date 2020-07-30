//
//  Tab ControllerViewController.swift
//  Picnic
//
//  Created by Kyle Burns on 5/25/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit
import FirebaseUI

class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .green
        tabBar.isTranslucent = false
        
        let controllers = [Featured(collectionViewLayout: CustomFlowLayout()), SettingsController()]
        
        viewControllers = controllers.map {
            UINavigationController(rootViewController: $0)
        }
        
        selectedIndex = 0
    }
    // Must be presented in viewDidAppear because window hierarchy is established between viewWillAppear and viewDidAppear.
    // This probably shouldn't be here
    override func viewDidAppear(_ animated: Bool) {
        guard let vc = Shared.shared.authManager.authUI?.authViewController() else {
            print("Error: TabController: viewDidAppear: viewController nil")
            return
        }
        vc.isModalInPresentation = true
        
        if let loginStatus = UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool {
            if loginStatus == false {
                present(vc, animated: true)
            } else {
                return
            }
        } else {
            present(vc, animated: true)
        }
    }
}

