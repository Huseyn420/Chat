//
//  ChatPresenter.swift
//  Chat
//
//  Created by Гусейн Агаев on 07.07.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import Foundation
import Firebase

protocol ChatScreenView: class {
    func messageOutput(text: String, time: Int, sender: String)
}

protocol ChatScreenPresenter {
    init(view: ChatScreenView, userId: String, interlocutorId: String)
    func receiveMessages()
    func sendingMessages(text: String)
}


final class ChatPresenter: ChatScreenPresenter {
    
    // MARK: - Private Properties
    
    private let userId: String
    private let interlocutorId: String
    
    unowned private let view: ChatScreenView
    
    // MARK: - Initialization
    
    required init(view: ChatScreenView, userId: String, interlocutorId: String) {
        self.interlocutorId = interlocutorId
        self.userId = userId
        self.view = view
    }
    
    // MARK: - Public Method
    
    func receiveMessages() {
        let ref = Database.database().reference().child("messages")

        ref.child(userId).child(interlocutorId).observe(.childAdded, with: { [weak self] (snapshot) in
            let message = Message(snapshot: snapshot)
            self?.view.messageOutput(text: message.text, time: message.time, sender: message.sender)
        }, withCancel: nil)
    }
    
    func sendingMessages(text: String) {
        let time = Int(Date().timeIntervalSince1970)
        let message = Message(text: text, time: time, sender: userId)
        let ref = Database.database().reference().child("messages")
        
        ref.child(userId).child(interlocutorId).childByAutoId().updateChildValues(message.convertToDictionary())
        ref.child(interlocutorId).child(userId).childByAutoId().updateChildValues(message.convertToDictionary())
    }
}
