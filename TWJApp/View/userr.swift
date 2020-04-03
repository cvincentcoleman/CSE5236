//
//  user.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 3/24/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import Foundation

struct Userr {
    let email: String
    let team: String
    let admin: Bool
    
    init(data: [String:Any]) {
        self.email = data["email"] as? String ?? "no email"
        self.team = data["team"] as? String ?? "no team"
        self.admin = data["admin"] as? Bool ?? false
    }
}
