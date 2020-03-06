//
//  InvoiceItem.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 3/4/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import UIKit

class InvoiceItem: NSObject {
    
    var amount : Int
    var team : String
    
    
    init(amount: Int, team: String) {
        self.amount = amount
        self.team = team
        
        super.init()
    }
    
    
}
