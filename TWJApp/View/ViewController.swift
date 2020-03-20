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


class ViewController: UIViewController {
    
    let emailInput: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email:"
        textField.backgroundColor = .none
        textField.addTarget(self, action: #selector(inputHandler), for: .editingChanged)
        return textField
    }()
    
    let passwordInput: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password:"
        textField.backgroundColor = .none
        textField.addTarget(self, action: #selector(inputHandler), for: .editingChanged)
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.isHidden = true
        button.addTarget(self, action: #selector(SignUpPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func inputHandler() {
        if emailInput.text?.count ?? 0 > 0 && passwordInput.text?.count ?? 0 > 0 {
            signUpButton.isHidden = false
        }
        else {
            signUpButton.isHidden = true
        }
        
    }
    
    @objc func SignUpPressed(){
        
        guard let email = emailInput.text else {return}
        guard let password = passwordInput.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) {user, error in
            if let error = error {
                print("error creating new user",error)
                return
            }
            print("User successfully created")
            
            guard let uid = user?.user.uid else {return}
            
            let userValues = ["email": email]
            let values = [uid: userValues]
            
            Database.database().reference().child("users").updateChildValues(values,withCompletionBlock: { (err, ref) in
                if let err = err {
                    print("failed to upload user" , err)
                    return
                }
                print("successfully uploaded user info")
            })
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(emailInput)
        view.addSubview(passwordInput)
        view.addSubview(signUpButton)
        
        emailInput.anchor(top: view.centerYAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, width: 0, heigth: 0, paddingTop: -75, paddingLeft: 50, paddingRight: 0, paddingBottom: 0)
        passwordInput.anchor(top: view.centerYAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, width: 0, heigth: 0, paddingTop: 0, paddingLeft: 50, paddingRight: 0, paddingBottom: 0)
        signUpButton.anchor(top: view.centerYAnchor, left: nil, right: nil, bottom: nil, width: 100, heigth: 50, paddingTop: 100, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
    }

}



