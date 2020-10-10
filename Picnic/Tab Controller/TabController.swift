//
//  Tab ControllerViewController.swift
//  Picnic
//
//  Created by Kyle Burns on 5/25/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit
import FirebaseUI
import GoogleSignIn

class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let controllers = [Featured(), SearchController(), Profile(), SettingsController()]
        
        viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
    
        let titles = ["Featured", "Search", "Profile", "Settings"]
        let imageNames = ["star", "magnifyingglass", "person", "gear"]
        for (index, item) in tabBar.items!.enumerated() {
            item.image = UIImage(systemName: imageNames[index])
            item.title = titles[index]
        }
        
        selectedIndex = 0
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    // Must be presented in viewDidAppear because window hierarchy is established between viewWillAppear and viewDidAppear.
    override func viewDidAppear(_ animated: Bool) {
        guard let vc = Managers.shared.authManager.authUI?.authViewController() else {
            print("Error: TabController: viewDidAppear: viewController nil")
            return
        }
        vc.isModalInPresentation = true
        
// MARK: Asks userManager if it should present sign in
        if Managers.shared.databaseManager.shouldRequestLogin() {
            present(vc, animated: true)
        }
    }
}

