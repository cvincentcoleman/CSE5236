//
//  HomeVC.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 2/12/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import UIKit
import Firebase




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
        //
        //            let profileImage = UIImageView()
        //            profileImage.load(url: url!)
        //            print(profileImage.image)
                    
                    let storageRef = Storage.storage().reference(forURL: url)
                    // Download the data, assuming a max size of 1MB (you can change this as necessary)
                    storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                          // Create a UIImage, add it to the array
                        let pic = UIImage(data: data!)
                        
                        self.addButton.setImage(pic, for: .normal)
                    }
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        let image = info[.editedImage] as? UIImage
        addButton.setImage(image, for: .normal)

        
        
        guard let compressedImage = image?.jpegData(compressionQuality: 0.2) else {return}
        let fileName = NSUUID().uuidString
        
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
}


