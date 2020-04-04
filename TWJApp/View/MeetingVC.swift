//
//  MeetingVC.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 3/6/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import UIKit
import Firebase




class MeetingVC: UITableViewController {

    var meetings: [Meeting] = []
    //need this due to a bug. Why can't I retrieve the data immedietly?
    var userInformation: Userr?
    
    var team:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            Database.database().reference().child("teams").child(userTeam).child("meetings").observe(.value) { (snapshot2) in
                
                var meetingNames: [String] = []
                let snapshotData = snapshot2.value as? [String:Any]
                snapshotData?.forEach({ (arg0) in
                    let (key, _) = arg0
                    meetingNames.append(key)
                })
                self.meetings = []
                meetingNames.forEach { (item) in
                    Database.database().reference().child("meetings").child(item).observe(.value) { (snapshot3) in
                        guard let meetings = Meeting.init(snapshot: snapshot3) else {return}
                        self.meetings.append(meetings)
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
        return meetings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingItem", for: indexPath)
        let row = indexPath.row
        cell.textLabel?.text = "Date: " +  meetings[row].date  + " Time: " + meetings[row].time + " Location: " + meetings[row].location
       
        
        
        return cell
    }
    
    @IBOutlet var addButton: UIBarButtonItem!
    
    @IBAction func addButtonDidTouch(_ sender: AnyObject){
        let alert = UIAlertController(title: "Meeting", message: "Add Meeting", preferredStyle: .alert)
        
        let saveMeeting = UIAlertAction(title: "Save Meeting", style: .default) { (_) in
            guard let meetingDateInput = alert.textFields?.first,
                let meetingDate = meetingDateInput.text,
                let meetingTimeInput = alert.textFields?[1],
                let meetingTime = meetingTimeInput.text,
                let meetingLocationInput = alert.textFields?.last,
                let meetingLocation = meetingLocationInput.text else {return}
            
            let invoiceRef = Database.database().reference().child("teams").child(self.team!).child("meetings").childByAutoId()
            invoiceRef.setValue(true)
            
            let invoiceKey = invoiceRef.key
            
            Database.database().reference().child("meetings").child(invoiceKey!).setValue(["date":meetingDate ,"time":meetingTime,"location":meetingLocation])
            
            
        }
        
        let cancelAddMeeting = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Date:"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Time:"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Location:"
        }
        alert.addAction(saveMeeting)
        alert.addAction(cancelAddMeeting)
        
        
        
        
        present(alert, animated: true, completion: nil)
        self.tableView.reloadData()

    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        let meeting = meetings[indexPath.row]
        
        Database.database().reference().child("teams").child(self.team!).child("meetings").child(meeting.ref.key!).removeValue()
        meeting.ref.removeValue()
        meetings = []
        self.tableView.reloadData()
      }
    }
    
   

}

struct Meeting {
    let date:String
    let location:String
    let time:String
    let ref:DatabaseReference
    
    init?(snapshot: DataSnapshot) {
        guard
            let data = snapshot.value as? [String:Any],
            let date = data["date"] as? String,
            let location = data["location"] as? String,
        let time = data["time"] as? String else {return nil}
        
        self.date = date
        self.location = location
        self.time = time
        self.ref = snapshot.ref
    }
}
