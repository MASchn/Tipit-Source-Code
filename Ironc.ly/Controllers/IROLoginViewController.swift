//
//  IROLoginViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 3/31/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROLoginViewController: UIViewController {

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.shadeView)
        self.view.addSubview(self.emailTextField)
        self.view.addSubview(self.passwordTextField)
        self.view.addSubview(self.signInButton)
        self.view.addSubview(self.signUpButton)
        
        self.setUpConstraints()
    }
    
    // MARK: - Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let emailBorder: CALayer = CALayer.createTextFieldBorder(textField: self.emailTextField)
        self.emailTextField.layer.addSublayer(emailBorder)
        self.emailTextField.layer.masksToBounds = true
        
        let passwordBorder: CALayer = CALayer.createTextFieldBorder(textField: self.passwordTextField)
        self.passwordTextField.layer.addSublayer(passwordBorder)
        self.passwordTextField.layer.masksToBounds = true
        
        self.signInButton.layer.cornerRadius = self.signInButton.frame.size.height / 2.0
        self.signUpButton.layer.cornerRadius = self.signUpButton.frame.size.height / 2.0
    }
    
    // MARK: - Lazy Initialization
    lazy var backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "login_background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var shadeView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var emailTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.textColor = UIColor.white
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        textField.font = UIFont(name: "HelveticaNeue", size: 15.0)
        let placeholder: NSAttributedString = NSAttributedString(
            string: "email",
            attributes:
            [
                NSFontAttributeName : UIFont(name: "Helvetica-LightOblique", size: 15.0)!,
                NSForegroundColorAttributeName : UIColor.white
            ]
        )
        textField.attributedPlaceholder = placeholder
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.textColor = UIColor.white
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.font = UIFont(name: "HelveticaNeue", size: 15.0)
        let placeholder: NSAttributedString = NSAttributedString(
            string: "password",
            attributes: [
                NSFontAttributeName : UIFont(name: "Helvetica-LightOblique", size: 15.0)!,
                NSForegroundColorAttributeName : UIColor.white
            ]
        )
        textField.attributedPlaceholder = placeholder
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var signInButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitleColor(IROConstants.darkGray, for: .normal)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.backgroundColor = IROConstants.green
        button.setTitle("Sign in", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        button.addTarget(self, action: #selector(self.tappedSignInButton), for: .touchUpInside)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let button: UIButton = UIButton()
        return button
    }()
    
    lazy var signUpButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitleColor(IROConstants.darkGray, for: .normal)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.backgroundColor = UIColor.white
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        button.addTarget(self, action: #selector(self.tappedSignUpButton), for: .touchUpInside)
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
        
        self.emailTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100.0).isActive = true
        self.emailTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.emailTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor).isActive = true
        self.passwordTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.passwordTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        self.signInButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 38.0).isActive = true
        self.signInButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.signInButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.signInButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        self.signUpButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40.0).isActive = true
        self.signUpButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.signUpButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.signUpButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }
    
    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    func pushMainScreen() {
        let tabBarController: IROTabBarController = IROTabBarController()
        tabBarController.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    func tappedSignInButton() {
        if self.emailTextField.text?.isEmpty == true || self.passwordTextField.text?.isEmpty == true {
            let alert: UIAlertController = UIAlertController(title: "Error", message: "Please fill in email and password fields", preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let email: String = self.emailTextField.text!
            let password: String = self.passwordTextField.text!
            IROAPIClient.logInUser(email: email, password: password, completionHandler: { (success: Bool) in
                if success == true {
                    self.pushMainScreen()
                } else {
                    print("Log in error")
                }
            })
        }
    }
    
    func tappedSignUpButton() {
        let registerViewController: IRORegisterViewController = IRORegisterViewController()
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }

}

extension IROLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
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
