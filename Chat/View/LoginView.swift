//
//  LoginViewController.swift
//  Chat
//
//  Created by Гусейн Агаев on 20.06.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import UIKit

final class LoginView: UIViewController {

    // MARK: - Private Properties
    
    private var presenter: LoginScreenPresenter?
    
    // Scroll view and its container
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: 0x2D3540)
        return view
    }()
    
    // Text fields and their container
    
    private let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.2)
        view.layer.borderColor = UIColor(hex: 0x000000, alpha: 0.4).cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        let colorPlac = UIColor(hex: 0xFFFFFF, alpha: 0.3)
        
        textField.textColor = .white
        textField.textContentType = .oneTimeCode
        textField.autocorrectionType = .no
        textField.attributedPlaceholder = NSAttributedString(string: "Name",  attributes: [NSAttributedString.Key.foregroundColor: colorPlac])
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        let colorPlac = UIColor(hex: 0xFFFFFF, alpha: 0.3)
        
        textField.textColor = .white
        textField.layer.borderWidth = 0.5
        textField.autocorrectionType = .no
        textField.textContentType = .oneTimeCode
        textField.layer.borderColor = UIColor(hex: 0x000000, alpha: 0.4).cgColor
        textField.attributedPlaceholder = NSAttributedString(string: "Email",  attributes: [NSAttributedString.Key.foregroundColor: colorPlac])
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        let colorPlac = UIColor(hex: 0xFFFFFF, alpha: 0.3)
        
        textField.textColor = .white
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.textContentType = .oneTimeCode
        textField.attributedPlaceholder = NSAttributedString(string: "Password",  attributes: [NSAttributedString.Key.foregroundColor: colorPlac])
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()
    
    // Login button
    
    private let loginRegisterButtonView: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(UIColor(hex: 0x2D3540), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(hex: 0xA0A4D9)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    // Segmented control
    
    private let loginRegisterSegmentedControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Login", "Register"])
        segmentControl.tintColor = UIColor(hex: 0x000000, alpha: 0.4)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return segmentControl
    }()
    
    // Image icons
    
    private let iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "AppIcon")
        icon.contentMode = .scaleAspectFill
        return icon
    }()
    
    // Height of variable elements
    
    private var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    private var nameTextFieldHeightAnchor: NSLayoutConstraint?
    private var emailTextFieldHeightAnchor: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPiece))
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addGestureRecognizer(tapGesture)
        
        presenter = LoginPresenter(view: self, email: nil, password: nil)
        presenter?.authorityCheck()
        
        [inputsContainerView, loginRegisterButtonView, iconImageView, loginRegisterSegmentedControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    
        setupStackViewConstraints()
        setupIconImageViewConstraints()
        setupInputContainerViewConstraints()
        setupRegisterButtonViewConstraints()
        setupLoginRegisterSegmentedControl()
        registerForKeyboardNotifications()
        
        view.backgroundColor = UIColor(hex: 0x2D3540)
    }
    
    // MARK: - Deinitialization
    
    deinit {
        removeKeyboardNotifications()
    }
    
    // MARK: - Private Methods
    
    // Layout
    
    private func setupStackViewConstraints() {
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
    }
    
    private func setupInputContainerViewConstraints() {
        inputsContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        inputsContainerView.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -30).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 100)
        inputsContainerViewHeightAnchor?.isActive = true
        
        [nameTextField, emailTextField, passwordTextField].forEach {
            $0.delegate = self
            $0.translatesAutoresizingMaskIntoConstraints = false
            inputsContainerView.addSubview($0)
        }
        
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalToConstant: 0)
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1 / 2)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor).isActive = true
    }
    
    private func setupRegisterButtonViewConstraints() {
        loginRegisterButtonView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        loginRegisterButtonView.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 20).isActive = true
        loginRegisterButtonView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButtonView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setupLoginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
    }
    
    private func setupIconImageViewConstraints() {
        iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        iconImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    // action when the keyboard appears and disappears
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: -
    
    @objc private func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo

        guard let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
         
        let result = kbFrameSize.origin.y - loginRegisterButtonView.frame.origin.y - loginRegisterButtonView.frame.height - 10
        
        if result < 0 {
            let shift = iconImageView.frame.height + iconImageView.frame.origin.y + 1
            scrollView.setContentOffset(CGPoint(x: 0, y: shift), animated: false)
        }
    }

    @objc private func kbWillHide() {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @objc private func tapPiece(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // change menu
    
    @objc private func handleLoginRegisterChange() {
        [inputsContainerViewHeightAnchor, nameTextFieldHeightAnchor, emailTextFieldHeightAnchor].forEach {
            $0?.isActive = false
        }
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            loginRegisterButtonView.setTitle("Sign In", for: .normal)
            nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalToConstant: 0)
            inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 100)
            emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1 / 2)
        } else {
            loginRegisterButtonView.setTitle("Sign Up", for: .normal)
            inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
            nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1 / 3)
            emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1 / 3)
        }
        
        [inputsContainerViewHeightAnchor, nameTextFieldHeightAnchor, emailTextFieldHeightAnchor].forEach {
            $0?.isActive = true
        }
    }
}


// MARK: - LoginScreenView
extension LoginView: LoginScreenView {
    
    // MARK: - Public Method
    
    func processingResult(error: String?) {
        if error == nil {
            let tabBar = TabBar()
            tabBar.modalTransitionStyle = .crossDissolve
            tabBar.modalPresentationStyle = .overCurrentContext
            present(tabBar, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2) {
              alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Private Method
    
    private func handleLogin() {
        guard emailTextField.text != "", passwordTextField.text != "" else {
            processingResult(error: "Not all fields are filled")
            return
        }
        
        presenter = LoginPresenter(view: self, email: emailTextField.text, password: passwordTextField.text)
        self.presenter?.processingDataLogin()
    }
    
    private func handleRegister() {
        guard emailTextField.text != "", passwordTextField.text != "", nameTextField.text != "" else {
            processingResult(error: "Not all fields are filled")
            return
        }
        
        presenter = LoginPresenter(view: self, name: nameTextField.text, email: emailTextField.text, password: passwordTextField.text)
        self.presenter?.processingDataRegistration()
    }
    
    @objc private func handleLoginRegister() {
        (loginRegisterSegmentedControl.selectedSegmentIndex == 0) ? handleLogin() : handleRegister()
    }
}


// MARK: - UITextFieldDelegate
extension LoginView: UITextFieldDelegate {
    
    // MARK: - Public Method
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            handleLoginRegister()
        }
        
        return true
    }
}
