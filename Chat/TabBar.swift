//
//  TabBar.swift
//  Cycle Trip
//
//  Created by Igor Lebedev on 21/04/2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import UIKit

final class TabBar: UITabBarController {

    // MARK: - Public Properties
    
    let messengerView = UINavigationController(rootViewController: MessengerView())
    let profileView = UINavigationController(rootViewController: ProfileView())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileView.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        messengerView.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))
        
        viewControllers = [messengerView, profileView]
        selectedIndex = 0
    }
}
