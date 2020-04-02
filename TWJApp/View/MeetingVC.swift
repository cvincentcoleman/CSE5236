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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [String :Any] else {return}
            self.userInformation = Userr.init(data: data)
            
            guard let userTeam = self.userInformation?.team else {
                return
            }
            
            Database.database().reference().child("teams").child(userTeam).child("meetings").observe(.value) { (snapshot2) in
                
                var meetingNames: [String] = []
                let snapshotData = snapshot2.value as? [String:Any]
                snapshotData?.forEach({ (arg0) in
                    let (key, _) = arg0
                    meetingNames.append(key)
                })
                
                meetingNames.forEach { (item) in
                    Database.database().reference().child("meetings").child(item).observe(.value) { (snapshot3) in
                        guard let meetings = Meeting.init(snapshot: snapshot3) else {return}
                        self.meetings.append(meetings)
                        print(self.meetings)
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
    
    
   

}

struct Meeting {
    let date:String
    let location:String
    let time:String
    
    init?(snapshot: DataSnapshot) {
        guard
            let data = snapshot.value as? [String:Any],
            let date = data["date"] as? String,
            let location = data["location"] as? String,
        let time = data["time"] as? String else {return nil}
        
        self.date = date
        self.location = location
        self.time = time
    }
}
