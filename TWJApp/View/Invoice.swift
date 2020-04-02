//
//  Invoice.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 4/1/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import UIKit
import Firebase

struct Invoice {
    let amount:String
    let paid:Bool
    let team:String
    
    init?(snapshot: DataSnapshot) {
        guard
            let data = snapshot.value as? [String:Any],
            let amount = data["amount"] as? String,
            let paid = data["paid"] as? Bool,
        let team = data["team"] as? String else {return nil}
        
        self.amount = amount
        self.paid = paid
        self.team = team
    }
}

