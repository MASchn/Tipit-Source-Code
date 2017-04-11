//
//  IROForgotPasswordViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 4/10/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROForgotPasswordViewController: UIViewController {

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.shadeView)
        self.view.addSubview(self.forgotPasswordLabel)
        self.view.addSubview(self.enterEmailLabel)
        self.view.addSubview(self.emailTextField)
        self.view.addSubview(self.submitButton)

        self.setUpConstraints()
    }
    
    // MARK: - Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.submitButton.layer.cornerRadius = self.submitButton.frame.size.height / 2.0
    }
    
    // MARK: - Lazy Initialization
    lazy var backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "forgot_password_background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var shadeView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var forgotPasswordLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 32.0, weight: UIFontWeightMedium)
        label.textAlignment = .center
        label.text = "Forgot\npassword?"
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var enterEmailLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18.0, weight: UIFontWeightMedium)
        label.textAlignment = .center
        label.text = "Enter your email address and\nwe will send you a link\nto reset your password"
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emailTextField: IROTextField = {
        let textField: IROTextField = IROTextField(placeholder: "email")
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var submitButton: IROButton = {
        let button: IROButton = IROButton(style: .green)
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(self.tappedSubmitButton), for: .touchUpInside)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        let hMargin: CGFloat = 35.0
        
        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.shadeView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.shadeView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.shadeView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.shadeView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.forgotPasswordLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 90.0).isActive = true
        self.forgotPasswordLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.forgotPasswordLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.forgotPasswordLabel.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        self.enterEmailLabel.topAnchor.constraint(equalTo: self.forgotPasswordLabel.bottomAnchor, constant: 80.0).isActive = true
        self.enterEmailLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.enterEmailLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.enterEmailLabel.heightAnchor.constraint(equalToConstant: 65.0).isActive = true
        
        self.emailTextField.topAnchor.constraint(equalTo: self.enterEmailLabel.bottomAnchor, constant: 65.0).isActive = true
        self.emailTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.emailTextField.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.submitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.submitButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.submitButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -hMargin).isActive = true
        self.submitButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    // MARK: - Actions
    func tappedSubmitButton() {
        guard self.emailTextField.hasText == true else {
            self.showAlert(title: "Please fill in email field", message: nil, completion: nil)
            return
        }
        
        guard IROValidator.isValidEmail(input: self.emailTextField.text!) == true else {
            self.showAlert(title: "Invalid email", message: nil, completion: nil)
            return
        }
        
        self.showAlert(title: "Reset request submitted", message: "Please follow the instructions sent to your email") { 
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}

extension IROForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
