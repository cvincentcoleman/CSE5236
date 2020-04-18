//
//  ViewController.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 2/7/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper


class LogInVC: UIViewController {
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.emailInput.text = nil
        self.passwordInput.text = nil
           
           Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {

                guard let uid = Auth.auth().currentUser?.uid else {return}

                Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                    guard let data = snapshot.value as? [String :Any] else {return}
                    guard let admin = data["admin"] as? Bool else {return}
                    if admin {
                        self.performSegue(withIdentifier: "adminLogIn", sender: nil)
                    }
                    else{
                        self.performSegue(withIdentifier: "logIn", sender: nil)
                    }
                }
                
               self.emailInput.text = nil
               self.passwordInput.text = nil
             }
        }
                
    }


    @IBOutlet var emailInput: UITextField!
    
    @IBOutlet var passwordInput: UITextField!
    
    @IBAction func SignIn (_ sender: AnyObject){

        guard
          let email = emailInput.text,
          let password = passwordInput.text,
          email.count > 0,
          password.count > 0
          else {
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { user, error in
          if let error = error, user == nil {
            print(error)
            
          }
        }
    }
    
    @IBAction func SignUp (_ sender: AnyObject){
        
        guard
          let email = emailInput.text,
          let password = passwordInput.text,
          email.count > 0,
          password.count > 0
          else {
            return
        }

        Auth.auth().createUser(withEmail: emailInput.text!, password: passwordInput.text!) { user, error in
          if error == nil {
            Auth.auth().signIn(withEmail: email,password: password)
            
            let account = ["email": email, "admin": true] as [String : Any]
            Database.database().reference().child("users").child(user!.user.uid).setValue(account)
            
          }
        }
        
    }
    

}

