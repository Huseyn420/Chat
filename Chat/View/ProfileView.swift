//
//  ProfileView.swift
//  Chat
//
//  Created by Гусейн Агаев on 02.07.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import UIKit
import Firebase

final class ProfileView: UIViewController {
    
    // MARK: - Private Properties
    
    private var presenter: ProfileScreenPresenter?
    
    private let imagePicker = UIImagePickerController()
    
    private let avatarImageView: UIImageView = {
        let avatar = UIImageView()
        avatar.alpha = 0.9
        avatar.image = UIImage(named: "Avatar")
        avatar.contentMode = .scaleAspectFill
        avatar.layer.cornerRadius = 30
        avatar.layer.borderWidth = 1.0
        avatar.layer.masksToBounds = true
        return avatar
    }()
    
    private let nameLabel: UILabel = {
        let name = UILabel()
        name.font =  UIFont.boldSystemFont(ofSize: 25.0)
        name.textColor = UIColor.ApplicationСolor.textActiveState
        name.textAlignment = .center
        return name
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.ApplicationСolor.background
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        [avatarImageView, nameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter = ProfilePresenter(view: self)
        presenter?.toGetData()
    }
    
    // MARK: - Private Method
    
    private func setupConstraints() {
        avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
    }
    
    @objc private func didTapImageView() {
        present(imagePicker, animated: true, completion: nil)
    }
}


// MARK: - ProfileScreenView
extension ProfileView: ProfileScreenView {
    
    // MARK: - Public Method
    
    func processingResult(name: String, email: String, url: String) {
        nameLabel.text = name
        avatarImageView.loadImageUsingCache(urlString: url)
    }
    
    func logout() {
        try? Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
}


// MARK: -  UIImagePickerControllerDelegate
extension ProfileView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: -  Public Method
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        avatarImageView.image = image
        presenter?.updateAvatar(image: avatarImageView.image)
        picker.dismiss(animated: true, completion: nil)
    }
}
