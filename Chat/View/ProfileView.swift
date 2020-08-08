//
//  ProfileView.swift
//  Chat
//
//  Created by Гусейн Агаев on 02.07.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MessageUI

final class ProfileView: UIViewController {
    
    // MARK: - Private Properties
    
    private var presenter: ProfileScreenPresenter?
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let identifier = "profileTableView"
    
    private let imagePicker = UIImagePickerController()
    
    private let avatarImageView: UIImageView = {
        let avatar = UIImageView()
        avatar.alpha = 0.8
        avatar.image = UIImage(named: "Avatar")
        avatar.contentMode = .scaleAspectFill
        avatar.layer.cornerRadius = 30
        avatar.layer.borderWidth = 1.0
        avatar.layer.borderColor = UIColor.ApplicationСolor.border.cgColor
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
    
    private let emailLabel: UILabel = {
        let email = UILabel()
        email.font = UIFont.systemFont(ofSize: 13.0)
        email.textColor = UIColor.ApplicationСolor.additionalText
        email.textAlignment = .center
        return email
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ProfilePresenter(view: self)
        view.backgroundColor = UIColor.ApplicationСolor.background
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.ApplicationСolor.separator
        tableView.backgroundColor = UIColor.ApplicationСolor.background
        tableView.register(ProfileCell.self, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        [avatarImageView, nameLabel, emailLabel, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.toGetData()
    }
    
    // MARK: - Private Method
    
    private func setupConstraints() {
        avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: min(view.bounds.width, view.bounds.height) * 1 / 4).isActive = true
        avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 15).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        tableView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc private func didTapImageView() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Change avatar", style: .default, handler: { (_) in
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            let image = UIImage(named: "Avatar")
            self.avatarImageView.image = image
            self.presenter?.deleteAvatar()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}


// MARK: - ProfileScreenView
extension ProfileView: ProfileScreenView {
    
    // MARK: - Public Method
    
    func processingResult(name: String, email: String, url: String) {
        nameLabel.text = name
        emailLabel.text = email
        avatarImageView.loadImageUsingCache(urlString: url)
    }
    
    @objc func logout() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference().child("messages").child(uid).removeAllObservers()
        try? Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    
    func alertAboutError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2) {
          alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func reloadEmailLabel(email: String) {
        emailLabel.text = email
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


// MARK: -  MFMailComposeViewControllerDelegate
extension ProfileView: MFMailComposeViewControllerDelegate {
    
    // MARK: -  Public Method
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


// MARK: -  UITableViewDelegate
extension ProfileView: UITableViewDelegate {
    
    // MARK: - Public Method

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            // Change name
            let message = "You want to change your name?\n(The string must not be empty)"
            let alert = UIAlertController(title: "Change name", message: message, preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.text = self.nameLabel.text
                textField.placeholder = "Full name"
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Change", style: .destructive, handler: { [weak alert] (_) in
                guard let name = alert?.textFields?.first?.text?.trimmingCharacters(in: NSCharacterSet.whitespaces), name != "" else {
                    return
                }
                
                self.nameLabel.text = name
                self.presenter?.updateName(newName: name)
            }))
            
            present(alert, animated: true, completion: nil)
        case (0, 1):
            // Change email
            let alert = UIAlertController(title: "Change email", message: nil, preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.returnKeyType = .next
                textField.placeholder = "New email"
            }
            alert.addTextField { (textField) in
                textField.isSecureTextEntry = true
                textField.textContentType = .password
                textField.placeholder = "Password"
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Change", style: .destructive, handler: { [weak alert] (_) in
                guard let email = alert?.textFields?[0].text?.trimmingCharacters(in: NSCharacterSet.whitespaces), email != "",
                let password = alert?.textFields?[1].text, password != "" else {
                        self.alertAboutError(message: "Not all fields are filled")
                    return
                }
                
                self.presenter?.updateEmail(newEmail: email, password: password)
            }))
            
            present(alert, animated: true, completion: nil)
        case (1, 0):
            // Change password
            let alert = UIAlertController(title: "Change password", message: nil, preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.returnKeyType = .next
                textField.isSecureTextEntry = true
                textField.textContentType = .password
                textField.placeholder = "Old password"
            }
            alert.addTextField { (textField) in
                textField.isSecureTextEntry = true
                textField.textContentType = .newPassword
                textField.placeholder = "New password(min. 6 characters)"
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Change", style: .destructive, handler: { [weak alert] (_) in
                guard let oldPassword = alert?.textFields?[0].text, let newPassword = alert?.textFields?[1].text else {
                    return
                }
                
                self.presenter?.updatePassword(oldPassword: oldPassword, newPassword: newPassword)
            }))
            
            present(alert, animated: true, completion: nil)
        case (2, 0):
            // Support service
            guard MFMailComposeViewController.canSendMail() else {
                alertAboutError(message: "Failed to open mail")
                return
            }
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["huseyn20@gmail.com"])
            mail.setSubject("Problem with messenger")
            present(mail, animated: true)
        case (2, 1):
            // Log out
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (_) in
                self.logout()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        default:
            alertAboutError(message: "Unexpected error")
        }
    }
}


// MARK: -  UITableViewDataSource
extension ProfileView: UITableViewDataSource {
    
    // MARK: -  Public Method
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let header = ["Editing", "Security", "Addition"]
        tableView.sectionHeaderHeight = 25
        return header[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProfileCell()
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell.textLabel?.text = "Change name"
            cell.imageView?.image = UIImage(systemName: "person.fill")
            cell.imageView?.backgroundColor = .gray
        case (0, 1):
            cell.textLabel?.text = "Change email"
            cell.imageView?.image = UIImage(systemName: "at")
            cell.imageView?.backgroundColor = UIColor(hex: 0x00008B)
        case (1, 0):
            cell.textLabel?.text = "Change password"
            cell.imageView?.image = UIImage(named: "key")
        case (1, 1):
            cell.textLabel?.text = "Biometric authentication systems"
            cell.imageView?.image = UIImage(named: "biometric")
            cell.addSwitch = true
            cell.biometrySwitch.isOn = UserDefaults.standard.bool(forKey: "additionalVerification")
        case (2, 0):
            cell.textLabel?.text = "Support service"
            cell.imageView?.image = UIImage(named: "support")
        case (2, 1):
            cell.textLabel?.text = "Log out"
            cell.imageView?.image = UIImage(named: "logout")
        default:
            cell.textLabel?.text = "Error"
        }
        
        return cell
    }
}
