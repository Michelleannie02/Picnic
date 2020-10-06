//
//  Shared.swift
//  Picnic
//
//  Created by Kyle Burns on 7/31/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//



final class Shared {
    static let shared = Shared()
    let picnicManager = PicnicManager(storagePathURL: "gs://picnic-1c64f.appspot.com/images")
    let locationManager = LocationManager()
    let authManager: AuthManager
    let userManager: UserManager
    
    private init() {
        authManager = AuthManager()
        userManager = UserManager()
        userManager.configure()
    }
}
