//
//  TeamOverviewVC.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 4/2/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import UIKit
import Firebase

class TeamOverviewVC: UIViewController{
    @IBOutlet var teamName: UILabel!
    var teamNameValue:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamName.text = teamNameValue
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInvoicesFromTeam" {
            let vc = segue.destination as? InvoiceVC
            vc?.team = teamNameValue
        }
        else if segue.identifier == "toMeetingsFromTeam" {
            let vc = segue.destination as? MeetingVC
            vc?.team = teamNameValue
        }
        else if (segue.identifier == "showMembers"){
           let vc = segue.destination as! MembersVC
           vc.team = teamNameValue
        }
    }
    
}

