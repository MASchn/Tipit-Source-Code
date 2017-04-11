//
//  IRORegisterViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 3/24/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit
import Alamofire

class IRORegisterViewController: UIViewController {

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.shadeView)
        self.view.addSubview(self.usernameTextField)
        self.view.addSubview(self.emailTextField)
        self.view.addSubview(self.passwordTextField)
        self.view.addSubview(self.signUpButton)
        self.view.addSubview(self.facebookButton)
        
        self.setUpConstraints()
    }
    
    // MARK: - Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let usernameBorder: CALayer = CALayer.createTextFieldBorder(textField: self.usernameTextField)
        self.usernameTextField.layer.addSublayer(usernameBorder)
        self.usernameTextField.layer.masksToBounds = true
        
        let emailBorder: CALayer = CALayer.createTextFieldBorder(textField: self.emailTextField)
        self.emailTextField.layer.addSublayer(emailBorder)
        self.emailTextField.layer.masksToBounds = true
        
        let passwordBorder: CALayer = CALayer.createTextFieldBorder(textField: self.passwordTextField)
        self.passwordTextField.layer.addSublayer(passwordBorder)
        self.passwordTextField.layer.masksToBounds = true
        
        self.signUpButton.layer.cornerRadius = self.signUpButton.frame.size.height / 2.0
        self.facebookButton.layer.cornerRadius = self.facebookButton.frame.size.height / 2.0
    }
    
    // MARK: - Lazy Initialization
    lazy var backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "register_background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var shadeView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var usernameTextField: IROTextField = {
        let textField: IROTextField = IROTextField(placeholder: "username")
        textField.autocapitalizationType = .none
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var emailTextField: IROTextField = {
        let textField: IROTextField = IROTextField(placeholder: "email")
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordTextField: IROTextField = {
        let textField: IROTextField = IROTextField(placeholder: "password")
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var signUpButton: IROButton = {
        let button: IROButton = IROButton(style: .clear)
        button.setTitle("Sign up", for: .normal)
        button.addTarget(self, action: #selector(self.tappedSignUpButton), for: .touchUpInside)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var facebookButton: IROButton = {
        let button: IROButton = IROButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.black, for: .highlighted)
        button.setTitle("Sign up with Facebook", for: .normal)
        button.backgroundColor = UIColor(red: 26/255.0, green: 106/255.0, blue: 199/255.0, alpha: 1.0)
        button.addTarget(self, action: #selector(self.tappedFacebookButton), for: .touchUpInside)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        
        let hMargin: CGFloat = 35.0
        let textFieldHeight: CGFloat = 50.0
        let buttonHeight: CGFloat = 50.0
        
        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.shadeView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.shadeView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.shadeView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.shadeView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.usernameTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100.0).isActive = true
        self.usernameTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.usernameTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.usernameTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        self.emailTextField.topAnchor.constraint(equalTo: self.usernameTextField.bottomAnchor).isActive = true
        self.emailTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.emailTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor).isActive = true
        self.passwordTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.passwordTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        self.signUpButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 38.0).isActive = true
        self.signUpButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.signUpButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.signUpButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
                
        self.facebookButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40.0).isActive = true
        self.facebookButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.facebookButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.facebookButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }
    
    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    // MARK: - Actions
    func tappedSignUpButton() {
        IROAPIClient.registerNewUser(
            username: self.usernameTextField.text!,
            email: self.emailTextField.text!,
            password: self.passwordTextField.text!
        ) { (success: Bool) in
            if success == true {
                self.pushMainScreen()
            } else {
                print("Could not register new user")
            }
        }
    }
    
    func tappedSignInButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Alert
    func presentAlert(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tappedFacebookButton() {
        let url: URL = URL(string: "https://powerful-reef-30384.herokuapp.com/auth/facebook")!
        UIApplication.shared.openURL(url)
    }
    
    func pushMainScreen() {
        
        
        let tabBarController: IROTabBarController = IROTabBarController()
        tabBarController.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
    
}

extension IRORegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.usernameTextField:
            self.emailTextField.becomeFirstResponder()
            return false
        case self.emailTextField:
            self.passwordTextField.becomeFirstResponder()
            return false
        case self.passwordTextField:
            self.passwordTextField.resignFirstResponder()
            return false
        default:
            break
        }
        
        return true
    }
    
}
