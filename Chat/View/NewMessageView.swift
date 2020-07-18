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
    
    private var sectionName: [String] = []
    private var data: [String: [(name: String, email: String, url: String, id: String)]] = [:]
    
    private let identifier = "tableViewCell"

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.ApplicationСolor.separator
        tableView.backgroundColor = UIColor.ApplicationСolor.background
        tableView.register(CorrespondenceCell.self, forCellReuseIdentifier: identifier)
        
        presenter = NewMessangePresenter(view: self)
        presenter?.fetchDataUser()
    }
    
    // MARK: - Public Method
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableView.sectionHeaderHeight = 25
        return sectionName[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[sectionName[section]]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CorrespondenceCell
        
        guard let section = data[sectionName[indexPath.section]] else {
            return cell
        }
        
        cell.textLabel?.text = section[indexPath.row].name
        cell.detailTextLabel?.text = section[indexPath.row].email
        cell.avatarImageView.loadImageUsingCache(urlString: section[indexPath.row].url)
        cell.separatorInset = UIEdgeInsets.zero
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatView = ChatView(collectionViewLayout: UICollectionViewFlowLayout())

        guard let section = data[sectionName[indexPath.section]] else {
            return
        }
        
        chatView.interlocutorId = section[indexPath.row].id
        chatView.navigationItem.title = section[indexPath.row].name
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(chatView, animated: true)
    }
}


// MARK: - NewMessengerScreenView
extension NewMessageView: NewMessageScreenView {

    // MARK: - Public Method

    func receiveUserData(name: String, email: String, url: String, id: String) {
        guard let key = name.first?.uppercased() else {
            return
        }
        
        if var values = data[key] {
            let index = values.insertionIndexOf(elem: (name, email, url, id), isOrderedBefore: { $0.name < $1.name })
            
            values.insert((name, email, url, id), at: index)
            data[key] = values
        } else {
            let index = sectionName.insertionIndexOf(elem: key, isOrderedBefore: {$0 < $1})
            
            data[key] = [(name, email, url, id)]
            sectionName.insert(key, at: index)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


// MARK: - UINavigationControllerDelegate
extension NewMessageView: UINavigationControllerDelegate {

    // MARK: - Public Method
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController.navigationItem.title = "Select user"
        navigationController.navigationBar.topItem?.backBarButtonItem = item
    }
}
