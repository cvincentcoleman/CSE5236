//
//  ViewExtension.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 3/19/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

//This idea was given to me by a tutorial in Letsbuildthatapp.com
extension UIView {
    //function allows us to add constraints more easily, in a more uniform way and illiminates the chances of getting some errors
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, width: CGFloat, heigth: CGFloat, paddingTop: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat, paddingBottom: CGFloat ) {
    
        //this is just an annoying thing you have to do to make things work. Doesn't really change anything but wont work w/o it
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if heigth != 0 {
            heightAnchor.constraint(equalToConstant: heigth).isActive = true
        }
    }
}
