//
//  ChatView.swift
//  Chat
//
//  Created by Гусейн Агаев on 06.07.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import Foundation
import UIKit
import Firebase

final class ChatView: UICollectionViewController {
    
    // MARK: - Public Properties
    
    var interlocutorId = String()
    
    let avatarInterlocutorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Avatar")
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    // MARK: - Private Properties
    
    private var presenter: ChatPresenter?
    
    private var containerViewBottomAnchor = NSLayoutConstraint()
    
    private var data: [(text: String, time: Int, sender: String)] = []
    private let identifier = "collectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.ApplicationСolor.background.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.ApplicationСolor.textButton, for: .normal)
        button.backgroundColor = UIColor(hex: 0xA0A4D9)
        button.addTarget(self, action: #selector(handlerSend), for: .touchUpInside)
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        return button
    }()
    
    private let messageTextField: UITextField = {
        let textField = UITextField()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.ApplicationСolor.textInactiveState]
        
        textField.textColor = .white
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.backgroundColor = UIColor.ApplicationСolor.interfaceUnit
        textField.layer.cornerRadius = 15
        textField.layer.borderWidth = 0.9
        textField.layer.borderColor = UIColor.ApplicationСolor.border.cgColor
        textField.attributedPlaceholder = NSAttributedString(string: "Enter message...",  attributes: attributes)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ApplicationСolor.separator
        return view
    }()
    
    private let bottomSafeArea: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ApplicationСolor.background
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPiece))
        
        collectionView.backgroundColor = UIColor.ApplicationСolor.background
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 70, right: 0)
        collectionView.keyboardDismissMode = .interactive
        
        [containerView, separator, bottomSafeArea].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        view.addGestureRecognizer(tapGesture)
        navigationController?.delegate = self
        messageTextField.delegate = self
        
        registerForKeyboardNotifications()
        setupInputsComponents()
        showAllPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sendButton.applyGradient(colours: UIColor.ApplicationСolor.brandButton)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Method
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MessageCell

        cell.bubbleWidthAnchor?.constant = estimateFrameForText(data[indexPath.row].text).width + 22
        cell.textLabel.text = data[indexPath.row].text
        cell.gradientColors = UIColor.ApplicationСolor.sentMessage
        
        if data[indexPath.row].sender == interlocutorId {
            cell.gradientColors = UIColor.ApplicationСolor.receivedMessage
        }
        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Private Method
    
    private func setupInputsComponents() {
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        containerViewBottomAnchor.isActive = true
        
        containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
       
        [sendButton, messageTextField].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.heightAnchor, constant: -20).isActive = true
        
        messageTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        messageTextField.centerYAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        messageTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -120).isActive = true
        messageTextField.heightAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.heightAnchor, constant: -20).isActive = true
        
        separator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        bottomSafeArea.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomSafeArea.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomSafeArea.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomSafeArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    // action when the keyboard appears and disappears
     
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
     
    @objc private func kbWillShow(_ notification: Notification) {
        let additionalOffset = view.safeAreaInsets.bottom
        let userInfo = notification.userInfo
        
        guard let kbFrameSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
        let kbDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        containerViewBottomAnchor.constant = -kbFrameSize.height + additionalOffset
        
        UIView.animate(withDuration: kbDuration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func kbWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let kbDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        self.containerViewBottomAnchor.constant = 0
        UIView.animate(withDuration: kbDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func tapPiece(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension ChatView: UICollectionViewDelegateFlowLayout {
    
    // MARK: - Public Method
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = data[indexPath.row].text
        let height = estimateFrameForText(text).height + 20
        return CGSize(width: view.frame.width, height: height)
    }
    
    // MARK: - Private Method
    
    private func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: view.frame.width * 3 / 4, height: view.frame.height * 3 / 2)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
}


// MARK: - ChatScreenView
extension ChatView: ChatScreenView {
    
    // MARK: - Public Method
    
    func messageOutput(text: String, time: Int, sender: String) {
        data.append((text, time, sender))
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Private Method
    
    private func showAllPosts() {
        guard let uid = Auth.auth().currentUser?.uid else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        presenter = ChatPresenter(view: self, userId: uid, interlocutorId: interlocutorId)
        presenter?.receiveMessages()
    }
    
    @objc private func handlerSend() {
        guard let messageText = messageTextField.text, messageText != "" else {
            return
        }
        
        messageTextField.text = nil
        presenter?.sendingMessages(text: messageText)
    }
}


// MARK: - UITextFieldDelegate
extension ChatView: UITextFieldDelegate {
 
    // MARK: - Public Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handlerSend()
        return false
    }
}


// MARK: - UINavigationControllerDelegate
extension ChatView: UINavigationControllerDelegate {

    // MARK: - Public Method
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(goBack))
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = item
    }
    
    // MARK: - Private Method

    @objc private func goBack() {
        navigationController?.popToRootViewController(animated: true)
    }
}
