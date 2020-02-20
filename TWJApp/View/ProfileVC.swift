//
//  HomeVC.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 2/12/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOut(_ sender: AnyObject){
        do{
            try Auth.auth().signOut()
            print("signedout")
            performSegue(withIdentifier: "signOut", sender: nil)
        } catch let err{
            print(err)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
