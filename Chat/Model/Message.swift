//
//  Message.swift
//  Chat
//
//  Created by Гусейн Агаев on 07.07.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Message {
    
    // MARK: - Public Properties
    
    let text: String
    let time: Int
    let sender: String

    // MARK: - Initialization
    
    init(text: String, time: Int, sender: String) {
        self.text = text
        self.time = time
        self.sender = sender
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? [String: AnyObject]
        text = snapshotValue?["text"] as? String ?? ""
        time = snapshotValue?["time"] as? Int ?? 0
        sender = snapshotValue?["sender"] as? String ?? ""
    }
    
    // MARK: - Public Method
    
    func convertToDictionary() -> [AnyHashable : Any] {
        return ["text": text, "time": time, "sender": sender]
    }
}
