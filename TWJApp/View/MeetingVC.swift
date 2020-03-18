//
//  MeetingVC.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 3/6/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import UIKit

class MeetingVC: UIViewController {
    
    let pressMeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Press Me", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "here i am"
        label.isEnabled = true
        label.textColor = .black
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pressMeButton)
        view.addSubview(label)
        
        pressMeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        pressMeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        label.topAnchor.constraint(equalTo: pressMeButton.bottomAnchor, constant: 20).isActive = true
        
        
        
    }
    
    
}
