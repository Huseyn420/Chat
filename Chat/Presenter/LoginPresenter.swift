//
//  LoginPresenter.swift
//  Chat
//
//  Created by Гусейн Агаев on 21.06.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import LocalAuthentication

protocol LoginScreenView: class {
    func processingResult(error: String?)
}

protocol LoginScreenPresenter {
    init(view: LoginScreenView)
    func processingDataRegistration(name: String?, email: String?, password: String?)
    func processingDataLogin(email: String?, password: String?)
    func authorityCheck()
}

final class LoginPresenter: LoginScreenPresenter {
    
    // MARK: - Private Properties

    unowned private let view: LoginScreenView
    
    // MARK: - Initialization
    
    required init(view: LoginScreenView) {
        self.view = view
    }
  
    // MARK: - Public Method
    
    func processingDataRegistration(name: String?, email: String?, password: String?) {
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
    
    func processingDataLogin(email: String?, password: String?) {
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
                let addVerification = UserDefaults.standard.bool(forKey: "additionalVerification")
                if addVerification == true {
                    self?.extraProtection()
                    return
                }
                
                self?.view.processingResult(error: nil)
            }
        }
    }
    
    // MARK: - Private Method
    
    private func extraProtection() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Authentication"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.view.processingResult(error: nil)
                    }
                }
            }
        } else {
            self.view.processingResult(error: nil)
        }
    }
}

