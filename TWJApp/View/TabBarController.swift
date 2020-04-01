//
//  TabBarController.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 4/1/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {
    
    var  userInformation : Userr?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [String :Any] else {return}
            self.userInformation = Userr.init(data: data)
        }
    }
    
    
}
