//
//  CreateMemberVC.swift
//  TWJApp
//
//  Created by Stephen Radvansky on 4/3/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper


class CreateMemberVC: UIViewController {
    
    
   @IBOutlet var emailInput : UITextField!
    
    var team : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.emailInput.text = nil
           
             
        }
            

    

@IBAction func SignUp (_ sender: AnyObject){
        
        guard
          let email = emailInput.text,
          email.count > 0
          else {
            return
        }
        let password = "123123"
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
          if error == nil {
            let account = ["email": email,"admin": false, "team" : self.team!] as [String : Any]
            Database.database().reference().child("users").child(user!.user.uid).setValue(account)
            Database.database().reference().child("teams").child(self.team!).child("members").child(user!.user.uid).setValue(true)
            self.emailInput.text = nil
          }
        }
        
    }
    



}
