//
//  File.swift
//  Chat
//
//  Created by Гусейн Агаев on 21.06.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

protocol MessengerScreenView: class {
    func dataProcessing(name: String, text: String, time: Int, url: String, interlocutor: String)
    func dataChange(text: String, time: Int, interlocutor: String)
    func handleLogout()
}

protocol MessengerScreenPresenter {
    init(view: MessengerScreenView)
    func receivingData()
}

final class MessengerPresenter: MessengerScreenPresenter  {
    
    // MARK: - Private Properties
    
    unowned private let view: MessengerScreenView
    
    // MARK: - Initialization
    
    required init(view: MessengerScreenView) {
        self.view = view
    }
    
    // MARK: - Public Method
    
    func receivingData() {
        let ref = Database.database().reference().child("messages")
        
        guard let uid = Auth.auth().currentUser?.uid else {
            self.view.handleLogout()
            return
        }
        
        ref.child(uid).observe(.childAdded, with: { [weak self] (snapshot) in
            if let messageSnapshot = snapshot.children.allObjects.last as? DataSnapshot {            
                let message = Message(snapshot: messageSnapshot)
                
                Database.database().reference().child("users").child(snapshot.key).observeSingleEvent(of: .value) { (snapshot) in
                    let user = User(snapshot: snapshot)
                    self?.view.dataProcessing(name: user.name, text: message.text, time: message.time, url: user.urlImage, interlocutor: snapshot.key)
                }
            }
        }, withCancel: nil)
        
        ref.child(uid).observe(.childChanged, with: { [weak self] (snapshot) in
            if let messageSnapshot = snapshot.children.allObjects.last as? DataSnapshot {
                let message = Message(snapshot: messageSnapshot)
                self?.view.dataChange(text: message.text, time: message.time, interlocutor: snapshot.key)
            }
        }, withCancel: nil)
    }
}
