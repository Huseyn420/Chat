//
//  NewMessageCell.swift
//  Chat
//
//  Created by Гусейн Агаев on 02.07.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import UIKit

class NewMessageCell: UITableViewCell {

    // MARK: - Public Properties
    
    let AvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Avatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0.1
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(hex: 0x2D3540, alpha: 0.8)
        
        textLabel?.textColor = UIColor(hex: 0xFFFFFF)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        detailTextLabel?.textColor = UIColor(hex: 0xFFFFFF)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        
        contentView.addSubview(AvatarImageView)
        setupLayoutAvatarImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Properties
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let textLabel = textLabel, let detailTextLabel = detailTextLabel else {
            return
        }
        
        textLabel.frame = CGRect(x: 84, y: textLabel.frame.origin.y - 2, width: textLabel.frame.width, height: textLabel.frame.height)
        detailTextLabel.frame = CGRect(x: 84, y: detailTextLabel.frame.origin.y + 2, width: detailTextLabel.frame.width, height: detailTextLabel.frame.height)
    }
    
    // MARK: - Private Properties
    
    private func setupLayoutAvatarImageView() {
        AvatarImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        AvatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        AvatarImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        AvatarImageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
    }
}
