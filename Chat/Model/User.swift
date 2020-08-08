//
//  User.swift
//  Chat
//
//  Created by Гусейн Агаев on 21.06.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct User {
    
    // MARK: - Public Properties
    
    let name: String
    let email: String
    let urlImage: String
    
    // MARK: - Initialization
    
    init(name: String, email: String, urlImage: String = "") {
        self.name = name
        self.email = email
        self.urlImage = urlImage
    }

    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? [String: AnyObject]
        email = snapshotValue?["email"] as? String ?? ""
        name = snapshotValue?["name"] as? String ?? ""
        urlImage = snapshotValue?["url"] as? String ?? ""
    }
    
    // MARK: - Public Method
    
    func convertToDictionary() -> [AnyHashable : Any] {
        return ["name": name, "email": email, "url": urlImage]
    }
}
