//
//  NewMessageView.swift
//  Chat
//
//  Created by Гусейн Агаев on 02.07.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import UIKit

final class NewMessageView: UITableViewController {
    
    // MARK: - Private Properties
    
    private var presenter: NewMessangePresenter?
    private var data: [(name: String, email: String, url: String)] = []
    
    private let identifier = "tableViewCell"

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor(hex: 0x2D3540, alpha: 1)
        tableView.backgroundColor = UIColor(hex: 0x2D3540, alpha: 1)
        tableView.register(NewMessageCell.self, forCellReuseIdentifier: identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        data.removeAll()
        presenter = NewMessangePresenter(view: self)
        presenter?.fetchDataUser()
    }
    
    // MARK: - Public Method
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! NewMessageCell
        
        cell.textLabel?.text = data[indexPath.row].name
        cell.detailTextLabel?.text = data[indexPath.row].email
        cell.AvatarImageView.loadImageUsingCache(urlString: data[indexPath.row].url)
        cell.separatorInset = UIEdgeInsets.zero
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - NewMessengerScreenView
extension NewMessageView: NewMessageScreenView {

    // MARK: - Public Method
    
    func openNewCorrespondence(name: String, email: String, url: String) {
        if name != "" && email != "" {
            data.append((name, email, url))
            self.tableView.reloadData()
        }
    }
}
