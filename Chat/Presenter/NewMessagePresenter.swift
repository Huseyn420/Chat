//
//  NewMessagePresenter.swift
//  Chat
//
//  Created by Гусейн Агаев on 02.07.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol NewMessageScreenView: class {
    func receiveUserData(name: String, email: String, url: String, id: String)
}

protocol NewMessageScreenPresenter {
    init(view: NewMessageScreenView)
    func fetchDataUser()
}

final class NewMessangePresenter: NewMessageScreenPresenter {
    
    // MARK: - Private Properties
    unowned private let view: NewMessageScreenView
    
    // MARK: - Initialization
    
    required init(view: NewMessageScreenView) {
        self.view = view
    }
    
    // MARK: - Public Method
    
    func fetchDataUser() {
        Database.database().reference().child("users").queryOrdered(byChild: "name").observe(.childAdded, with: { [weak self] (snapshot) in
            let user = User(snapshot: snapshot)
            self?.view.receiveUserData(name: user.name, email: user.email, url: user.urlImage, id: snapshot.key)
        }, withCancel: nil)
    }
}
