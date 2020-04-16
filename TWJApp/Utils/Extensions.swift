//
//  Extensions.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 4/15/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import UIKit

//https://stackoverflow.com/questions/39398282/retrieving-image-from-firebase-storage-using-swift
extension UIImageView{
    func load(url: URL){
        
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
                self.image = image
            }
                               
        }.resume()
    }
}
