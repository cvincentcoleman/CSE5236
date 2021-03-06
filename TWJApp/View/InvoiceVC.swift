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

//fix this so that it only sends over the team and not the user
class InvoiceVC: UITableViewController {
    
    var invoices: [Invoice] = []
    //need this due to a bug. Why can't I retrieve the data immedietly?
    var userInformation: Userr?
    
    var team:String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        invoices = []
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [String :Any] else {return}
            self.userInformation = Userr.init(data: data)
            
            
            
            guard var userTeam = self.userInformation?.team else {
                return
            }
            
            if self.userInformation?.admin ?? false {
                userTeam = self.team!
                self.addButton.isEnabled = true
            } else{
                self.addButton.isEnabled = false
            }
           
            
            Database.database().reference().child("teams").child(userTeam).child("invoices").observe(.value) { (snapshot2) in
                
                var invoiceNames: [String] = []
                let snapshotData = snapshot2.value as? [String:Any]
                snapshotData?.forEach({ (arg0) in
                    let (key, _) = arg0
                    invoiceNames.append(key)
                })
                self.invoices = []
                invoiceNames.forEach { (item) in
                    Database.database().reference().child("invoices").child(item).observe(.value) { (snapshot3) in
                        guard let invoice = Invoice.init(snapshot: snapshot3) else {return}
                        self.invoices.append(invoice)
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
    
    @IBOutlet var addButton: UIBarButtonItem!
    
    @IBAction func addButtonDidTouch(_ sender: AnyObject){
        let alert = UIAlertController(title: "Invoice", message: "Add Invoice", preferredStyle: .alert)
        
        let saveInvoice = UIAlertAction(title: "Save Invoice", style: .default) { (_) in
            guard let invoiceInput = alert.textFields?.first,
                let invoiceAmount = invoiceInput.text else {return}
            
            let invoiceRef = Database.database().reference().child("teams").child(self.team!).child("invoices").childByAutoId()
            invoiceRef.setValue(true)
            
            let invoiceKey = invoiceRef.key
            
            Database.database().reference().child("invoices").child(invoiceKey!).setValue(["amount":Double(invoiceAmount)! ,"team":self.team!,"paid":false])
            
            
        }
        
        let cancelAddInvoice = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveInvoice)
        alert.addAction(cancelAddInvoice)
        
        
        
        
        present(alert, animated: true, completion: nil)
        self.tableView.reloadData()

    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        let invoice = invoices[indexPath.row]
        
        Database.database().reference().child("teams").child(self.team!).child("invoices").child(invoice.invoiceRef.key!).removeValue()
        invoice.invoiceRef.removeValue()
        invoices = []
        self.tableView.reloadData()
      }
    }
    
    
}



struct Invoice {
    let amount:Double
    let paid:Bool
    let team:String
    let invoiceRef: DatabaseReference
    
    init?(snapshot: DataSnapshot) {
        guard
            let data = snapshot.value as? [String:Any],
            let amount = data["amount"] as? Double,
            let paid = data["paid"] as? Bool,
            let team = data["team"] as? String else {return nil}
        
        
        self.amount = amount
        self.paid = paid
        self.team = team
        self.invoiceRef = snapshot.ref
    }
}
