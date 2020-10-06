//
//  User.swift
//  Picnic
//
//  Created by Kyle Burns on 10/3/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import FirebaseFirestoreSwift
struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var rated: [String]?
    var saved: [String]?
}


