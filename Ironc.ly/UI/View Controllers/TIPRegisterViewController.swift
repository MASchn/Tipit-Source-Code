//
//  TIPRegisterViewController.swift
//  Ironc.ly
//

import UIKit
import Alamofire
import FBSDKLoginKit

class TIPRegisterViewController: UIViewController {

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
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var usernameTextField: TIPTextField = {
        let textField: TIPTextField = TIPTextField(placeholder: "username")
        textField.autocapitalizationType = .none
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var emailTextField: TIPTextField = {
        let textField: TIPTextField = TIPTextField(placeholder: "email")
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordTextField: TIPTextField = {
        let textField: TIPTextField = TIPTextField(placeholder: "password")
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var signUpButton: TIPButton = {
        let button: TIPButton = TIPButton(style: .clear)
        button.setTitle("Sign up", for: .normal)
        button.addTarget(self, action: #selector(self.tappedSignUpButton), for: .touchUpInside)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var facebookButton: TIPButton = {
        let button: TIPButton = TIPButton(style: .facebook)
        button.setTitle("Sign up with Facebook", for: .normal)
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
        
        self.usernameTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 140.0).isActive = true
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
        guard
            self.usernameTextField.hasText == true,
            self.emailTextField.hasText == true,
            self.passwordTextField.hasText == true
        else
        {
            self.showAlert(title: "Please fill in all fields", message: nil, completion: nil)
            return
        }
        
        let username: String = self.usernameTextField.text!
        let email: String = self.emailTextField.text!
        let password: String = self.passwordTextField.text!
        
        guard TIPValidator.isValidUsername(input: username) else {
            self.showAlert(title: "Invalid username", message: nil, completion: nil)
            return
        }
        
        guard TIPValidator.isValidEmail(input: email) else {
            self.showAlert(title: "Invalid email", message: nil, completion: nil)
            return
        }
        
        guard TIPValidator.isValidPassword(input: password) else {
            self.showAlert(title: "Invalid password", message: "Password must be longer than 6 characters", completion: nil)
            return
        }
        
        TIPAPIClient.registerNewUser(
            username: self.usernameTextField.text!,
            email: self.emailTextField.text!,
            password: self.passwordTextField.text!
        ) { (success: Bool) in
            if success == true {
                self.navigationController?.dismiss(animated: true, completion: nil)
            } else {
                print("Could not register new user")
            }
        }
    }
    
    func tappedSignInButton() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func tappedFacebookButton() {
//        let url: URL = URL(string: "https://powerful-reef-30384.herokuapp.com/auth/facebook")!
//        UIApplication.shared.openURL(url)
    
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            
            if error != nil {
                print("failed to log in\(error)")
                return
            }
            
            self.registerFBUser()
            //print("COOL", FBSDKAccessToken.current())
        }
        
    }
    
    
    func registerFBUser() {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
            (connection, result, error) in
            
            if error != nil {
                print("failed to start graph request\(error)")
                return
            }
            
            let resultDict = result! as! [String: Any]
            
            print("RES: \(resultDict)")
            print("RES[0]: \(resultDict["email"])")
            
            let email: String = resultDict["email"] as! String
            let name: String = resultDict["name"] as! String
            let id: String = resultDict["id"] as! String
            
            
            TIPAPIClient.registerNewUser(
                username: name,
                email: email,
                password: id
            ) { (success: Bool) in
                if success == true {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                } else {
                    print("Could not register new user")
                }
            }
            
        }
    }
    
}

extension TIPRegisterViewController: UITextFieldDelegate {
    
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
