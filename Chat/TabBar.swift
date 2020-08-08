//
//  TabBar.swift
//  Chat
//
//  Created by Гусейн Агаев on 02.07.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import UIKit

final class TabBar: UITabBarController {

    // MARK: - Public Properties
    
    let messengerView = UINavigationController(rootViewController: MessengerView())
    let profileView = UINavigationController(rootViewController: ProfileView())
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileView.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        messengerView.tabBarItem = UITabBarItem(title: "Messenger", image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))
        
        viewControllers = [messengerView, profileView]
        selectedIndex = 0
    }
}
