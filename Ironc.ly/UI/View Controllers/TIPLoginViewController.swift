//
//  TIPLoginViewController.swift
//  Ironc.ly
//

import UIKit
import FBSDKLoginKit

class TIPLoginViewController: UIViewController {

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.shadeView)
        self.view.addSubview(self.emailTextField)
        self.view.addSubview(self.passwordTextField)
        self.view.addSubview(self.signInButton)
        self.view.addSubview(self.facebookButton)
        self.view.addSubview(self.forgotPasswordButton)
        self.view.addSubview(self.signUpButton)
        
        self.setUpConstraints()
    }
        
    // MARK: - Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.signInButton.layer.cornerRadius = self.signInButton.frame.size.height / 2.0
        self.signUpButton.layer.cornerRadius = self.signUpButton.frame.size.height / 2.0
        self.facebookButton.layer.cornerRadius = self.facebookButton.frame.size.height / 2.0
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
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        textField.textColor = UIColor.white
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var signInButton: TIPButton = {
        let button: TIPButton = TIPButton(style: .green)
        button.setTitle("Sign in", for: .normal)
        button.addTarget(self, action: #selector(self.signIn), for: .touchUpInside)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var facebookButton: TIPButton = {
        let button: TIPButton = TIPButton(style: .facebook)
        button.setTitle("Sign in with Facebook", for: .normal)
        button.addTarget(self, action: #selector(self.tappedFacebookButton), for: .touchUpInside)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//    lazy var facebookButton: FBSDKLoginButton = {
//        let button: FBSDKLoginButton = FBSDKLoginButton()
//        //button.setTitle("Sign in with Facebook", for: .normal)
//        //button.addTarget(self, action: #selector(self.tappedFacebookButton), for: .touchUpInside)
//        button.clipsToBounds = true
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.readPermissions = ["email", "public_profile"]
//        button.delegate = self
//        return button
//    }()
    
    lazy var forgotPasswordButton: TIPButton = {
        let button: TIPButton = TIPButton(style: .text)
        button.setTitle("Forgot password?", for: .normal)
        button.addTarget(self, action: #selector(self.tappedForgotPasswordButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var signUpButton: TIPButton = {
        let button: TIPButton = TIPButton(style: .white)
        button.setTitle("Sign up", for: .normal)
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
        
        self.emailTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 140.0).isActive = true
        self.emailTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.emailTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor).isActive = true
        self.passwordTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.passwordTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        self.signInButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 35.0).isActive = true
        self.signInButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.signInButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.signInButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        self.facebookButton.topAnchor.constraint(equalTo: self.signInButton.bottomAnchor, constant: 20.0).isActive = true
        self.facebookButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.facebookButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.facebookButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        self.forgotPasswordButton.topAnchor.constraint(equalTo: self.facebookButton.bottomAnchor, constant: 12.0).isActive = true
        self.forgotPasswordButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.forgotPasswordButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.forgotPasswordButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
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
    
    func signIn() {
        if self.emailTextField.text?.isEmpty == true || self.passwordTextField.text?.isEmpty == true {
            self.showAlert(title: "Please fill in all fields", message: nil, completion: nil)
        } else {
            let email: String = self.emailTextField.text!
            let password: String = self.passwordTextField.text!
            
            let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
            
            TIPAPIClient.logInUser(email: trimmedEmail, password: password, completionHandler: { (success: Bool) in
                if success == true {
                    
                    TIPAPIClient.updateUser(parameters: [:], completionHandler: { (success: Bool) in
                        if success == true {
                            self.emailTextField.text = ""
                            self.passwordTextField.text = ""
                            self.view.endEditing(true)
                            self.navigationController?.dismiss(animated: true, completion: nil)
                        } else {
                            self.showAlert(title: "Could not pull rest of user info", message: "An error occurred", completion: nil)
                        }
                    })
                } else {
                    self.showAlert(title: "Incorrect email or password", message: "Please try again", completion: nil)
                }
            })
        }
    }
    
    func tappedFacebookButton() {
//        let url: URL = URL(string: "https://powerful-reef-30384.herokuapp.com/auth/facebook")!
//        UIApplication.shared.openURL(url)
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            
            if error != nil {
                print("failed to log in\(error)")
                return
            }
            
            self.logInFBUser()
            //print("COOL", FBSDKAccessToken.current())
        }
    }
    
    func tappedForgotPasswordButton() {
        let forgotPasswordViewController: TIPForgotPasswordViewController = TIPForgotPasswordViewController()
        self.navigationController?.pushViewController(forgotPasswordViewController, animated: true)
    }
    
    func tappedSignUpButton() {
        let registerViewController: TIPRegisterViewController = TIPRegisterViewController()
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }

}

extension TIPLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.emailTextField:
            self.passwordTextField.becomeFirstResponder()
            return false
        case self.passwordTextField:
            self.passwordTextField.resignFirstResponder()
            self.signIn()
            return false
        default:
            break
        }
        
        return true
    }
    
}

extension TIPLoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
//        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
//            (connection, result, error) in
//            
//            if error != nil {
//                print("failed to start graph request\(error)")
//                return
//            }
//            
//            let resultDict = result! as! [String: Any]
//            
//            print("RES: \(resultDict)")
//            print("RES[0]: \(resultDict["email"])")
//            
//            let email: String = resultDict["email"] as! String
//            let name: String = resultDict["name"] as! String
//            let id: String = resultDict["id"] as! String
//            let password: String = "general"
//            
//            TIPAPIClient.logInUser(email: email, password: password, completionHandler: { (success: Bool) in
//                if success == true {
//                    
//                    TIPAPIClient.updateUser(parameters: [:], completionHandler: { (success: Bool) in
//                        if success == true {
////                            self.emailTextField.text = ""
////                            self.passwordTextField.text = ""
////                            self.view.endEditing(true)
//                            self.navigationController?.dismiss(animated: true, completion: nil)
//                        } else {
//                            self.showAlert(title: "Could not pull rest of user info", message: "An error occurred", completion: nil)
//                        }
//                    })
//                } else {
//                    self.showAlert(title: "User doesnt exist", message: "Make new user", completion: nil)
//                }
//            })
//            
//        }
        
    }
    
    func logInFBUser() {
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
            let password: String = "general"
            
            TIPAPIClient.logInUser(email: email, password: password, completionHandler: { (success: Bool) in
                if success == true {
                    
                    TIPAPIClient.updateUser(parameters: [:], completionHandler: { (success: Bool) in
                        if success == true {
                            //                            self.emailTextField.text = ""
                            //                            self.passwordTextField.text = ""
                            //                            self.view.endEditing(true)
                            self.navigationController?.dismiss(animated: true, completion: nil)
                        } else {
                            self.showAlert(title: "Could not pull rest of user info", message: "An error occurred", completion: nil)
                        }
                    })
                } else {
                    self.showAlert(title: "User doesnt exist", message: "Make new user", completion: nil)
                }
            })
            
        }
    }
    
}
