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
    //need this due to a bug. Why can't I retrieve the data immedietly?
    var userInformation: Userr?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [String :Any] else {return}
            self.userInformation = Userr.init(data: data)
            
            guard let userTeam = self.userInformation?.team else {
                return
            }
            
            Database.database().reference().child("teams").child(userTeam).child("invoices").observe(.value) { (snapshot2) in
                
                var invoiceNames: [String] = []
                let snapshotData = snapshot2.value as? [String:Any]
                snapshotData?.forEach({ (arg0) in
                    let (key, _) = arg0
                    invoiceNames.append(key)
                })
                
                invoiceNames.forEach { (item) in
                    Database.database().reference().child("invoices").child(item).observe(.value) { (snapshot3) in
                        guard let invoice = Invoice.init(snapshot: snapshot3) else {return}
                        self.invoices.append(invoice)
                        print(self.invoices)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceItem", for: indexPath)
        let row = indexPath.row
        cell.textLabel?.text =   String(format: "amount: %.2f", invoices[row].amount)
        if (!invoices[row].paid){
            cell.tintColor = .white
        }
        
        
        return cell
    }
    
}



struct Invoice {
    let amount:Double
    let paid:Bool
    let team:String
    
    init?(snapshot: DataSnapshot) {
        guard
            let data = snapshot.value as? [String:Any],
            let amount = data["amount"] as? Double,
            let paid = data["paid"] as? Bool,
        let team = data["team"] as? String else {return nil}
        
        self.amount = amount
        self.paid = paid
        self.team = team
    }
}
