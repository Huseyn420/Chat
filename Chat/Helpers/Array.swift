//
//  Array.swift
//  Chat
//
//  Created by Гусейн Агаев on 11.07.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import Foundation

// MARK: - Array
extension Array {
    
    // MARK: - Public Method
    
    func insertionIndexOf(elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var low = 0
        var high = self.count - 1
        
        while low <= high {
            let middle = (low + high) / 2
            
            if isOrderedBefore(self[middle], elem) {
                low = middle + 1
            } else if isOrderedBefore(elem, self[middle]) {
                high = middle - 1
            } else {
                return middle
            }
        }
        
        return low
    }
}
