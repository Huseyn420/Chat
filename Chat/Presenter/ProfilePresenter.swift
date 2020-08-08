//
//  ProfilePresenter.swift
//  Chat
//
//  Created by Гусейн Агаев on 02.07.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

protocol ProfileScreenView: class {
    func processingResult(name: String, email: String, url: String)
    func alertAboutError(message: String)
    func reloadEmailLabel(email: String)
    func logout()
}

protocol ProfileScreenPresenter {
    init(view: ProfileScreenView)
    func updateName(newName: String)
    func updateAvatar(image: UIImage?)
    func deleteAvatar()
    func toGetData()
    func updateEmail(newEmail: String, password: String)
    func updatePassword(oldPassword: String, newPassword: String)
}

final class ProfilePresenter: ProfileScreenPresenter {

    // MARK: - Private Properties
    
    unowned private let view: ProfileScreenView
    
    // MARK: - Initialization
    
    required init(view: ProfileScreenView) {
        self.view = view
    }
    
    // MARK: - Public Method
    
    func toGetData() {
        guard let uid = Auth.auth().currentUser?.uid else {
            view.logout()
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            let user = User(snapshot: snapshot)
            self?.view.processingResult(name: user.name, email: user.email, url: user.urlImage)
        }
    }
    
    func updateEmail(newEmail: String, password: String) {
        guard let email = Auth.auth().currentUser?.email, let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { [weak self] (_, error) in
            if let error = error {
                self?.view.alertAboutError(message: error.localizedDescription)
                return
            }
            
            Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { [weak self] (error) in
                if let error = error {
                    self?.view.alertAboutError(message: error.localizedDescription)
                    return
                }
                
                Database.database().reference().child("users").child(uid).updateChildValues(["email": newEmail] as [String : Any])
                self?.view.reloadEmailLabel(email: newEmail)
            })
        })
    }
    
    func updatePassword(oldPassword: String, newPassword: String) {
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { [weak self] (authResult, error) in
            if let error = error {
                self?.view.alertAboutError(message: error.localizedDescription)
                return
            }
            
            guard let user = authResult?.user else {
                return
            }
            
            user.updatePassword(to: newPassword, completion: { (error) in
                if let error = error {
                    self?.view.alertAboutError(message: error.localizedDescription)
                    return
                }
            })
        })
    }
    
    func updateName(newName: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference().child("users").child(uid).updateChildValues(["name": newName] as [String : Any])
    }
    
    func updateAvatar(image: UIImage?) {
        guard let data = image?.pngData(), let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let riversRef = Storage.storage().reference().child(uid)
        
        riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard error == nil else {
                return
            }
            
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url?.absoluteURL, error == nil else {
                    return
                }
                
                let url = "\(downloadURL)"
                let ref = Database.database().reference().child("users").child(uid)
                let update = ["url": url] as [String : Any]
                
                ref.updateChildValues(update) { (error, ref) in
                    guard error == nil else {
                        return
                    }
                }
            }
        }
    }
    
    func deleteAvatar() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference().child("users").child(uid).child("url").removeValue()
    }
}
