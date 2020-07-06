//
//  ProfilePresenter.swift
//  Chat
//
//  Created by Гусейн Агаев on 02.07.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import UIKit
import Firebase

protocol ProfileScreenView: class {
    func processingResult(name: String, email: String, url: String)
    func logout()
}

protocol ProfileScreenPresenter {
    init(view: ProfileScreenView)
    func updateAvatar(image: UIImage?)
    func toGetData()
}

class ProfilePresenter: ProfileScreenPresenter {

    // MARK: - Private Properties
    
    unowned private let view: ProfileScreenView
    
    // MARK: - Initialization
    
    required init(view: ProfileScreenView) {
        self.view = view
    }
    
    // MARK: - Public Method
    
    func toGetData() {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.view.logout()
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            let user = User(snapshot: snapshot)
            self?.view.processingResult(name: user.name, email: user.email, url: user.urlImage)
        }
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
}
