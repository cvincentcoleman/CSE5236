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
    
    var teamNameValue:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamName.text = teamNameValue
        
    }
    
    @IBOutlet var teamName: UILabel!
    
}

