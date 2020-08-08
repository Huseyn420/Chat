//
//  ChatHeader.swift
//  Chat
//
//  Created by Гусейн Агаев on 30.07.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import Foundation
import UIKit

final class ChatHeader: UICollectionReusableView {

    // MARK: - Public Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.ApplicationСolor.textActiveState
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.ApplicationСolor.background
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    // MARK: - Public Method

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
