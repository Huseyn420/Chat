//
//  CustomColor.swift
//  Cycle Trip
//
//  Created by Гусейн Агаев on 20.04.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import UIKit

extension UIColor {
    
    // MARK: - Initialization
    
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // MARK: - ApplicationColor
    
    struct ApplicationСolor {
        static var background: UIColor  { return UIColor(hex: 0x2D3540) }
        static var interfaceUnit: UIColor { return UIColor(hex: 0x000000, alpha: 0.2) }
        
        static var textButton: UIColor { return UIColor(hex: 0x2D3540) }
        static var messageText: UIColor { return UIColor(hex: 0x000000) }
        static var additionalText: UIColor { return UIColor(hex: 0xD7D7D7) }
        static var textActiveState: UIColor { return UIColor(hex: 0xFFFFFF) }
        static var textInactiveState: UIColor { return UIColor(hex: 0xFFFFFF, alpha: 0.3) }
        
        static var separator: UIColor { return UIColor(hex: 0x000000) }
        static var border: UIColor { return UIColor(hex: 0xFFFFFF, alpha: 0.4) }
        
        static var sentMessage: [UIColor] { return [UIColor(hex: 0xDFEC51), UIColor(hex: 0x73AA0A)] }
        static var receivedMessage: [UIColor] { return [UIColor(hex: 0xB3B3B3), UIColor(hex: 0x909090)] }
        static var brandButton: [UIColor] { return [UIColor(hex: 0x1DE5E2), UIColor(hex: 0xB588F7)] }
    }
}
