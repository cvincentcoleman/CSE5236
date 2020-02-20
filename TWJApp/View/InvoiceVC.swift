//
//  InvoiceVC.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 2/15/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class InvoiceVC: UIViewController {
    
    //properties
    var db: Firestore!
    var user: User!
    var ref: DatabaseReference!
    var userRef: DatabaseReference!
    
    
    override func viewDidLoad(){
        
        ref = Database.database().reference()
        
        // [START setup]
               let settings = FirestoreSettings()

               Firestore.firestore().settings = settings
               // [END setup]
               db = Firestore.firestore()
        
        if Auth.auth().currentUser != nil {
          // User is signed in.
          user = Auth.auth().currentUser
        } else {
          // No user is signed in.
          // ...
        }
        print ("UID:"+user.uid)
        
        
        userRef = Database.database().reference().child("users").child(user.uid)
        
//        SETS VALUE
//        self.ref.child("users").child(user.uid).child("team").setValue("TWJ")
//        self.ref.child("teams").child("TWJ").child("members").setValue([user.uid: true])
        
//         ref.child("invoices").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
//           // Get user value
//           let value = snapshot.value as? NSDictionary
//           let username = value?["username"] as? String ?? ""
//           let user = User(username: username)
//
//           // ...
//           }) { (error) in
//             print(error.localizedDescription)
//         }

        
    }
}
