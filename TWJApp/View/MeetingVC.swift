//
//  MeetingVC.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 3/6/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import UIKit
import Firebase




class MeetingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        
        let tabbar = self.tabBarController as! TabBarController
        
        guard let userEmail = tabbar.userInformation?.email else {return}
        
        print(userEmail)
        print(tabbar.userInformation?.email)

        
        
    
    }
    
   

}
