//
//  Date.swift
//  Chat
//
//  Created by Гусейн Агаев on 30.07.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import Foundation

extension Date {
    
    // MARK: - Public Method
    
    func convertTime() -> String {
        let dateFormatter = DateFormatter()
        var dateString = String()
        
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        
        if Calendar.current.isDate(self, inSameDayAs: Date()) {
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .none
        }
        
        dateString = (self > Date(timeIntervalSince1970: 0.0)) ? dateFormatter.string(from: self) : "Error"
        return dateString
    }
}
