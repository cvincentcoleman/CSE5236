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
    
    init(data: [String:Any]) {
        self.email = data["email"] as? String ?? "not working"
        self.team = data["team"] as? String ?? "noteam"
    }
}
