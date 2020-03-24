//
//  user.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 3/24/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import Foundation

struct Userr {
    let username: String
    
    init(data: [String:Any]) {
        self.username = data["email"] as? String ?? "not working"
    }
}
