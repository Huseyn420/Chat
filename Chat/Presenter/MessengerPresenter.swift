//
//  File.swift
//  Chat
//
//  Created by Гусейн Агаев on 21.06.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import Foundation
import Firebase

protocol MessengerScreenView: class {
    func dataProcessing(name: String, email: String)
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
        guard let uid = Auth.auth().currentUser?.uid else {
            self.view.handleLogout()
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            let user = User(snapshot: snapshot)
            self?.view.dataProcessing(name: user.name, email: user.email)
        }
    }
}
