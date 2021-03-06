//
//  SettingsController.swift
//  Picnic
//
//  Created by Kyle Burns on 7/29/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import FirebaseUI

class SettingsController: UIViewController {
    
    var logoutButton: UIButton!
    var authUI: FUIAuth? = FUIAuth.defaultAuthUI()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        
        logoutButton = UIButton()
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.red, for: .normal)
        logoutButton.isSpringLoaded = true
        logoutButton.showsTouchWhenHighlighted = true
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.14),
            logoutButton.heightAnchor.constraint(equalTo: logoutButton.widthAnchor, multiplier: 0.5)
        ])
    }
    
    @objc func logout(_ sender: UIButton) {
        do {
            try Managers.shared.auth.signOut()
        } catch {
            print(error.localizedDescription)
        }
        tabBarController?.selectedIndex = 0
        if let vc = authUI?.authViewController() {
            vc.isModalInPresentation = true
            tabBarController?.present(vc, animated: true)
        }
    }
}
