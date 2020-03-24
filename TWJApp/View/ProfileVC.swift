//
//  HomeVC.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 2/12/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [String :Any] else {return}
            let userr = Userr.init(data: data)
            self.userLabel.text = userr.username
        
        
        }
        
        
    
    }
    
    @IBOutlet var userLabel: UILabel!
    
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
