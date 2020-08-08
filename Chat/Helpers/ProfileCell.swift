//
//  ProfileCell.swift
//  Chat
//
//  Created by Гусейн Агаев on 19.07.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import Foundation
import UIKit

final class ProfileCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    var addSwitch = false
    let biometrySwitch = UISwitch()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
         
        backgroundColor = UIColor.ApplicationСolor.interfaceUnit
        
        textLabel?.textColor = UIColor.ApplicationСolor.textActiveState
        textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        imageView?.tintColor = .white
        imageView?.contentMode = .scaleAspectFill
        imageView?.layer.cornerRadius = 10
        imageView?.layer.masksToBounds = true
        
        biometrySwitch.translatesAutoresizingMaskIntoConstraints = false
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Method
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var widthLabel = frame.width - 80
        guard let textLabel = textLabel, let imageView = imageView else {
            return
        }
        
        if addSwitch {
            addSubview(biometrySwitch)
            biometrySwitch.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
            biometrySwitch.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
            biometrySwitch.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            widthLabel = frame.width - biometrySwitch.frame.width - 85
        }

        imageView.frame = CGRect(x: 15, y: (frame.height - 30) / 2, width: 30, height: 30)
        textLabel.frame = CGRect(x: 60, y: 2, width: widthLabel, height: frame.height - 2)
        separatorInset = UIEdgeInsets.zero
    }
    
    @objc func handleSwitchAction(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "additionalVerification")
            return
        }
        
        UserDefaults.standard.set(false, forKey: "additionalVerification")
    }
}

