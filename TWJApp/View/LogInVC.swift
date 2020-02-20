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
 
           
           Auth.auth().addStateDidChangeListener() { auth, user in
             if user != nil {
               
               self.performSegue(withIdentifier: "logIn", sender: nil)
               self.emailInput.text = nil
               self.passwordInput = nil
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

        Auth.auth().createUser(withEmail: emailInput.text!, password: passwordInput.text!) { user, error in
          if error == nil {
            Auth.auth().signIn(withEmail: self.emailInput.text!,
                               password: self.passwordInput.text!)
          }
        }
        
    }
    

}

