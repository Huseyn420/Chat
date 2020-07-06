//
//  MessengerView.swift
//  Chat
//
//  Created by Гусейн Агаев on 20.06.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import UIKit
import Firebase

final class MessengerView: UITableViewController {

    // MARK: - Private Properties
    
    private var presenter: MessengerScreenPresenter?
    
    private let newMessengerImage = UIImage(named: "new_message_icon")
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.barStyle = .black
        view.backgroundColor = UIColor(hex: 0x2D3540, alpha: 1)
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: newMessengerImage, style: .plain, target: self, action: #selector(handleNewMessage))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter = MessengerPresenter(view: self)
        presenter?.receivingData()
    }
    
    // MARK: - Private Method
    
    @objc private func handleNewMessage() {
        self.navigationController?.pushViewController(NewMessageView(), animated: true)
    }
}


// MARK: - MessengerScreenView
extension MessengerView: MessengerScreenView {
   
    // MARK: - Public Method
    
    func dataProcessing(name: String, email: String) {
        self.navigationItem.title = name
    }
    
    @objc func handleLogout() {
        try? Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
}
