//
//  MessengerView.swift
//  Chat
//
//  Created by Гусейн Агаев on 20.06.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

final class MessengerView: UITableViewController {

    // MARK: - Private Properties
    
    private var presenter: MessengerScreenPresenter?
    
    private var data: [(name: String, text: String, time: Int, url: String, interlocutor: String)] = []
    
    private let newMessengerImage = UIImage(named: "newMessage")
    private let identifier = "messengerTableViewCell"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.ApplicationСolor.background
        
        navigationController?.delegate = self
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.ApplicationСolor.separator
        tableView.backgroundColor = UIColor.ApplicationСolor.background
        tableView.register(CorrespondenceCell.self, forCellReuseIdentifier: identifier)
        
        presenter = MessengerPresenter(view: self)
        presenter?.receivingData()
    }
    
    // MARK: - Public Method
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CorrespondenceCell else {
            fatalError("Cell should be not nil")
        }
        
        let date = Date(timeIntervalSince1970: Double(data[indexPath.row].time))
        
        cell.textLabel?.text = data[indexPath.row].name
        cell.detailTextLabel?.text = data[indexPath.row].text
        cell.timeLabel.text = date.convertTime()
        cell.avatarImageView.loadImageUsingCache(urlString: data[indexPath.row].url)
        cell.separatorInset = UIEdgeInsets.zero
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatView = ChatView(collectionViewLayout: UICollectionViewFlowLayout())
        
        chatView.hidesBottomBarWhenPushed = true
        chatView.interlocutorId = data[indexPath.row].interlocutor
        chatView.navigationItem.title = data[indexPath.row].name
        
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(chatView, animated: true)
    }
}


// MARK: - MessengerScreenView
extension MessengerView: MessengerScreenView {
   
    // MARK: - Public Method
    
    func dataProcessing(name: String, text: String, time: Int, url: String, interlocutor: String) {
        let index = data.insertionIndexOf(elem: (name, text, time, url, interlocutor), isOrderedBefore: { $0.time > $1.time })
        data.insert((name, text, time, url, interlocutor), at: index)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func dataChange(text: String, time: Int, interlocutor: String) {
        for (index, message) in data.enumerated() {
            if message.interlocutor == interlocutor {
                data.remove(at: index)
                data.insert((message.name, text, time, message.url, interlocutor), at: 0)
                break
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func handleLogout() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference().child("messages").child(uid).removeAllObservers()
        try? Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UINavigationControllerDelegate
extension MessengerView: UINavigationControllerDelegate {

    // MARK: - Public Method
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let leftItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let rightItem = UIBarButtonItem(image: newMessengerImage, style: .plain, target: self, action: #selector(handleNewMessage))
        
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        navigationItem.title = "Messenger"
    }
    
    // MARK: - Private Method
    
    @objc private func handleNewMessage() {
        let newMessageView = NewMessageView()
        newMessageView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(newMessageView, animated: true)
    }
}
