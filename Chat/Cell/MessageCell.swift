//
//  MessageCell.swift
//  Chat
//
//  Created by Гусейн Агаев on 13.07.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import Foundation
import UIKit

final class MessageCell: UICollectionViewCell {
    
    // MARK: - Public Properties

    var bubleTrailingAnchor: NSLayoutConstraint?
    var bubleLeadingAnchor: NSLayoutConstraint?
    var bubbleWidthAnchor: NSLayoutConstraint?
    
    var gradientColors: [UIColor] = []
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = UIColor.ApplicationСolor.messageText
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .right
        return label
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLabel.text = nil
        bubbleView.layer.sublayers?.removeFirst()
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [bubbleView, textLabel, timeLabel].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addSubview(bubbleView)
        bubbleView.addSubview(textLabel)
        bubbleView.addSubview(timeLabel)
        constraintMessage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Method
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bubbleView.applyGradient(colours: gradientColors)
        
        bubleLeadingAnchor?.isActive = false
        bubleTrailingAnchor?.isActive = true
        
        if gradientColors == UIColor.ApplicationСolor.receivedMessage {
            bubleTrailingAnchor?.isActive = false
            bubleLeadingAnchor?.isActive = true
        }
    }
    
    // MARK: - Private Method
    
    private func constraintMessage() {
        
        bubleLeadingAnchor = bubbleView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8)
        bubleLeadingAnchor?.isActive = false
        
        bubleTrailingAnchor = bubbleView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)
        bubleTrailingAnchor?.isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        textLabel.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor, constant: -5).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: bubbleView.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        
        timeLabel.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 2).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -10).isActive = true
    }
}
