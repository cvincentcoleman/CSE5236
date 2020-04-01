//
//  InvoiceVC.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 2/15/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class InvoiceVC: UITableViewController {
    
    var invoices: [Invoice] = []
    
    
    override func viewDidLoad(){
        
        print("HEY")
        
        
        
         

       // guard let userTeam = userLoggedIn?.team else {return}
//        Database.database().reference().child("teams").child(userTeam).child("invoices").observe(.value) { (snapshot) in
//            for child in snapshot.children{
//                print(child)
//            }
//        }

    }
}

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
