//
//  LoginPresenter.swift
//  Chat
//
//  Created by Гусейн Агаев on 21.06.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import Foundation
import Firebase

protocol LoginScreenView: class {
    func processingResult(error: String?)
}

protocol LoginScreenPresenter {
    init(view: LoginScreenView, name: String?, email: String?, password: String?)
    func processingDataRegistration()
    func processingDataLogin()
    func authorityCheck()
}

final class LoginPresenter: LoginScreenPresenter {
    
    // MARK: - Private Properties
    
    private let name: String?
    private let email: String?
    private let password: String?
    
    unowned private let view: LoginScreenView
    
    // MARK: - Initialization
    
    required init(view: LoginScreenView, name: String? = nil, email: String?, password: String?) {
        self.view = view
        self.name = name
        self.email = email
        self.password = password
    }
  
    // MARK: - Public Method
    
    func processingDataRegistration() {
        guard let name = name, let email = email, let password = password else {
            self.view.processingResult(error: "Not all fields are filled")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            guard error == nil, let uid = user?.user.uid else {
                self?.view.processingResult(error: error?.localizedDescription)
                return
            }
                
            let ref = Database.database().reference()
            let userReference = ref.child("users").child(uid)
            let values = User(name: name, email: email).convertToDictionary()
                
            userReference.updateChildValues(values, withCompletionBlock: { (errror, ref) in
                guard error == nil else {
                    self?.view.processingResult(error: error?.localizedDescription)
                    return
                }
                
                self?.view.processingResult(error: nil)
            })
        }
    }
    
    func processingDataLogin() {
        guard let email = email, let password = password else {
            self.view.processingResult(error: "Not all fields are filled")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            guard error == nil else {
                self?.view.processingResult(error: error?.localizedDescription)
                return
            }
            
            self?.view.processingResult(error: nil)
        }
    }
    
    func authorityCheck() {
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.view.processingResult(error: nil)
            }
        }
    }
}

