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
        
        self.setUpConstraints()
    }
    
    // MARK: - Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let usernameBorder: CALayer = self.createTextFieldBorder(textField: self.usernameTextField)
        self.usernameTextField.layer.addSublayer(usernameBorder)
        self.usernameTextField.layer.masksToBounds = true
        
        let emailBorder: CALayer = self.createTextFieldBorder(textField: self.emailTextField)
        self.emailTextField.layer.addSublayer(emailBorder)
        self.emailTextField.layer.masksToBounds = true
        
        let passwordBorder: CALayer = self.createTextFieldBorder(textField: self.passwordTextField)
        self.passwordTextField.layer.addSublayer(passwordBorder)
        self.passwordTextField.layer.masksToBounds = true
        
        self.signUpButton.layer.cornerRadius = self.signUpButton.frame.size.height / 2.0
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
    
    lazy var usernameTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.textColor = UIColor.white
        textField.font = UIFont(name: "Helvetica-LightOblique", size: 15.0)
        textField.autocapitalizationType = .none
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        let placeholder: NSAttributedString = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName : UIColor.white])
        textField.attributedPlaceholder = placeholder
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var emailTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.textColor = UIColor.white
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        textField.font = UIFont(name: "Helvetica-LightOblique", size: 15.0)
        let placeholder: NSAttributedString = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName : UIColor.white])
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
        textField.font = UIFont(name: "Helvetica-LightOblique", size: 15.0)
        let placeholder: NSAttributedString = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        textField.attributedPlaceholder = placeholder
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var signUpButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(self.tappedSignUpButton), for: .touchUpInside)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var facebookButton: UIButton = {
        let button: UIButton = UIButton()
        return button
    }()
    
    func createTextFieldBorder(textField: UITextField) -> CALayer {
        let width: CGFloat = 1.0
        let border: CALayer = CALayer()
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: textField.frame.size.width, height: textField.frame.size.height)
        border.borderColor = UIColor.white.cgColor
        border.borderWidth = width
        return border
    }
    
    // MARK: - Autolayout
    func setUpConstraints() {
        
        let hMargin: CGFloat = 35.0
        let textFieldHeight: CGFloat = 50.0
        
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
        self.signUpButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    // MARK: - Actions
    func tappedSignUpButton() {
        let parameters: Parameters = [
            "username" : "\(self.usernameTextField.text!)",
            "email" : "\(self.emailTextField.text!)",
            "password" : "\(self.passwordTextField.text!)"
        ]
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        Alamofire.request(
            "https://powerful-reef-30384.herokuapp.com/users",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: header
        ).responseJSON { (response) in
            switch response.result {
            case .success(let JSON):
                let response: [String : Any] = JSON as! [String : Any]
                print(response["email"])
            case .failure(let error):
                print("Sign up request failed with error \(error)")
            }
        }
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
