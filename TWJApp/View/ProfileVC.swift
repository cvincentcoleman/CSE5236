//
//  HomeVC.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 2/12/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseStorage




class ProfileVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let tabbar = self.tabBarController as! TabBarController
        
        guard let userEmail = tabbar.userInformation?.email else {return}
        userLabel.text = userEmail
        
        if (tabbar.userInformation?.ProfileimageURL.count != 0){
        //
            let url = tabbar.userInformation!.ProfileimageURL
            
            let httpsReference = Storage.storage().reference(forURL: url)
                
            let profilePicture = UIImageView()
            let pp = UIImageView()
            load(url: URL(string: url)!)
                
            pp.sizeToFit()
                
            let placeholderImage = UIImage(named: "addButton")
        
            profilePicture.sd_setImage(with: httpsReference, placeholderImage: placeholderImage)
            
            self.addButton.setImage(pp.image, for: .normal)
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
    
    @IBOutlet var addButton: UIButton!
    
    @IBAction func addButtonPressed(_ sender: AnyObject){
        print("addButtonPressed")
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let action = UIAlertController(title: "Add Profile Image", message: nil, preferredStyle: .actionSheet)
        
        
        let libraryAction =  UIAlertAction(title: "Photo Library", style: .default, handler: { (UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        })
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            action.dismiss(animated: true, completion: nil)
        }
        action.addAction(libraryAction)
        action.addAction(cameraAction)
        action.addAction(cancelAction)
        
        self.present(action,animated: true,completion: nil)
        
    }
    
    
    @IBAction func changePassword(_ sender: AnyObject){
    
        let alert = UIAlertController(title: "Password", message: "Choose a new password", preferredStyle: .alert)
        
        let dissmiss = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        let changePassword = UIAlertAction(title: "Change Password", style: .default) { (UIAlertAction) in
            guard let oldPasswordInput = alert.textFields?.first,
                let oldPassword = oldPasswordInput.text else {return}
            
            guard let newPasswordInput = alert.textFields?.last,
            let newPassword = newPasswordInput.text else {return}
            
            let user = Auth.auth().currentUser
            var credential : AuthCredential
                
            // Prompt the user to re-provide their sign-in credentials
            credential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: oldPassword)

            //NOTES
            //reauth works, need to retrieve old passwords and input them in credentials along with actual email.
            user?.reauthenticate(with: credential, completion: { (result, error) in
                
                let comfirmationAlert = UIAlertController(title: "Password Updated", message: nil, preferredStyle: .alert)

                if let error = error{
                    print("error with Reauth", error)
                    comfirmationAlert.title = "Passsword Update Failed"
                    comfirmationAlert.message = "Please try again"
                }
                else{
                    Auth.auth().currentUser?.updatePassword(to: newPassword) { (error) in
                        
                        if let error = error{
                            print(error)
                            comfirmationAlert.title = "Passsword Update Failed"
                            comfirmationAlert.message = "Please try again"
                        }
                    }
                }
                comfirmationAlert.addAction(dissmiss)
                self.present(comfirmationAlert, animated:  true, completion: nil)
            })
            
        }
        
        let cancelChangePassword = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Current Password"
            textField.isSecureTextEntry = true
        }
        alert.addTextField { (textField) in
            textField.placeholder = "New Password"
            textField.isSecureTextEntry = true
        }
        alert.addAction(changePassword)
        alert.addAction(cancelChangePassword)
        
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        let image = info[.editedImage] as? UIImage
        addButton.setImage(image, for: .normal)

        
        
        guard let compressedImage = image?.jpegData(compressionQuality: 0.2) else {return}
        var fileName = NSUUID().uuidString
        fileName = fileName + ".jpg"
        
        let storageRef = Storage.storage().reference().child("profileImages").child(fileName)
        storageRef.putData(compressedImage, metadata: nil) { (metadata, err) in
            
            if let err = err {
                print("photo upload failed",err)
                return
            }
            
            storageRef.downloadURL { (url, err) in
                if let err = err {
                    print("coulden't download url",err)
                }
                let uid = Auth.auth().currentUser?.uid
                
                Database.database().reference().child("users").child(uid!).child("profileImageURL").setValue(url?.absoluteString)
                
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    fileprivate func load(url: URL){
        
           
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //check for the error, then construct the image using data
            if let err = err {
                print("Failed to fetch profile image:", err)
                return
            }
            //perhaps check for responce of 200 (HTTP success)
               
            guard let data = data else {return}
            let image = UIImage(data: data)
               
            //need to get back on to the main thread
            DispatchQueue.main.async {
                self.addButton.setImage(image, for: .normal)
            }
        }.resume()
    }
}


