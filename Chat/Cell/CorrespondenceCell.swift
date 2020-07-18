//
//  CorrespondenceCell.swift
//  Chat
//
//  Created by Гусейн Агаев on 02.07.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import UIKit

final class CorrespondenceCell: UITableViewCell {

    // MARK: - Public Properties
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Avatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0.1
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.ApplicationСolor.additionalText
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - View Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        timeLabel.text = nil
        avatarImageView.image = nil
        detailTextLabel?.text = nil
        textLabel?.text = nil
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.ApplicationСolor.background
        
        textLabel?.textColor = UIColor.ApplicationСolor.textActiveState
        textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        detailTextLabel?.textColor = UIColor.ApplicationСolor.textActiveState
        detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        
        [avatarImageView, timeLabel].forEach() {
            contentView.addSubview($0)
        }
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
        
        timeLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel.heightAnchor).isActive = true
        timeLabel.adjustsFontSizeToFitWidth = true
        
        avatarImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        let freeSpaceForTextLabel = timeLabel.frame.width + 110

        textLabel.frame = CGRect(x: 84, y: textLabel.frame.origin.y - 2, width: frame.width - freeSpaceForTextLabel, height: textLabel.frame.height)
        detailTextLabel.frame = CGRect(x: 84, y: detailTextLabel.frame.origin.y + 2, width: frame.width - 100, height: detailTextLabel.frame.height)
    }
}
