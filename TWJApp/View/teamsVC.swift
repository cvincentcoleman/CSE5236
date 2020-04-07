//
//  teamsVC.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 4/2/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import UIKit
import Firebase

class TeamsVC: UITableViewController{
    
    var teams: [String] = []
    //need to fix this
     var userInformation: Userr?
     
     
     override func viewDidLoad() {
         super.viewDidLoad()
        
        
        Database.database().reference().child("teams").observe(.value) { (snapshot) in
            self.teams = []
            
            let snapshotData = snapshot.value as? [String:Any]
            snapshotData?.forEach({ (arg0) in
                let (key, _) = arg0
                self.teams.append(key)
                self.tableView.reloadData()
            })
        }
         
         
     }
     override func numberOfSections(in tableView: UITableView) -> Int {
         1
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return teams.count
     }
    
    var teamName:String!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let cell = tableView.cellForRow(at: indexPath)
        teamName = cell?.textLabel?.text

        performSegue(withIdentifier: "TeamDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? TeamOverviewVC {
            self.tableView.reloadData()
            viewController.teamNameValue = teamName
        }
    }
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "TeamItem", for: indexPath)
         let row = indexPath.row
         cell.textLabel?.text = teams[row]
        
         return cell
     }
    
    
    
    
    @IBAction func addButtonDidTouch(_ sender: AnyObject){
        let alert = UIAlertController(title: "Team", message: "Add Team", preferredStyle: .alert)
        
        let saveInvoice = UIAlertAction(title: "Save Team", style: .default) { (_) in
            guard let teamInput = alert.textFields?.first,
                let team = teamInput.text else {return}
            
            let invoiceRef = Database.database().reference().child("teams").child(team)
          
            invoiceRef.setValue(["exists":true])
        }
        
        let cancelAddInvoice = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveInvoice)
        alert.addAction(cancelAddInvoice)
        
        
        
        
        present(alert, animated: true, completion: nil)
        self.tableView.reloadData()

    }
     
    
}
