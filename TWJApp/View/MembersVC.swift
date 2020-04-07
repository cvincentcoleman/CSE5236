//
//  MembersVC.swift
//  TWJApp
//
//  Created by Stephen Radvansky on 4/3/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import UIKit
import Firebase

class MembersVC: UITableViewController{
    
    var accounts: [String] = []
    var emails: [String] = []
    //need to fix this
     var userInformation: Userr?
     
    var team : String?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("teams").child(team!).child("members").observe(.value) { (snapshot) in
            
        
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let check = child.value as! Bool
                if(check){
                    self.accounts.append(child.key)
                }
                
            }
            for key in self.accounts {
                Database.database().reference().child("users").child(key + "/email").observe(.value) { (snapshot2) in
                    self.emails.append(snapshot2.value as! String)
                    self.tableView.reloadData()
                }
            }
            
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.accounts = []
        self.emails = []
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "createMember" {
               let vc = segue.destination as? CreateMemberVC
               vc?.team = team
           }
    }
     override func numberOfSections(in tableView: UITableView) -> Int {
         1
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return emails.count
     }
    
    var teamName:String!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("hi")

        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let cell = tableView.cellForRow(at: indexPath)
        teamName = cell?.textLabel?.text

    }
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "MemberItem", for: indexPath)
         let row = indexPath.row
         cell.textLabel?.text = emails[row]
        
         return cell
     }
    
    
    
    
}
