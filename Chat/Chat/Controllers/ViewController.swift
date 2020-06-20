//
//  ViewController.swift
//  Chat
//
//  Created by Гусейн Агаев on 20.06.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: 0x2D3540, alpha: 1)
        self.navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogin))
    }
    
    @objc func handleLogin() {
        let login = LoginViewController()
        
        login.modalTransitionStyle = .crossDissolve
        login.modalPresentationStyle = .overCurrentContext
        present(login, animated: true, completion: nil)
    }
}
