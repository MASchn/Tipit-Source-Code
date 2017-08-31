//
//  TIPLoginViewController.swift
//  Ironc.ly
//

import UIKit
import FBSDKLoginKit
import SendBirdSDK



class TIPLoginViewController: UIViewController {

    var signInTop: NSLayoutConstraint?
    var signUpTop: NSLayoutConstraint?
    var logoTop: NSLayoutConstraint?
    var cancelTop: NSLayoutConstraint?
    var getPasswordTop: NSLayoutConstraint?
    var emailTop: NSLayoutConstraint?
    
    var fontSize: CGFloat = 18.0
    
    static let backgroundPicArray = [#imageLiteral(resourceName: "crumpled"), #imageLiteral(resourceName: "tipitbackground2_7"), #imageLiteral(resourceName: "tipitbackground3_7"), #imageLiteral(resourceName: "tipitbackground4_7"), #imageLiteral(resourceName: "tipitbackground5_7"), #imageLiteral(resourceName: "graph_paper")]
    var backgoundPicSelection: Int = 0
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UIApplication.shared.statusBarStyle = .default
        
        let screen = UIScreen.main
        self.fontSize = screen.bounds.size.height * (18.0 / 568.0)
        if (screen.bounds.size.height < 500) {
            self.fontSize = screen.bounds.size.height * (18.0 / 480.0)
        }
        
        self.backgroundImageView.image = TIPLoginViewController.backgroundPicArray[self.backgoundPicSelection]
        
        self.view.backgroundColor = .white

        self.view.addSubview(self.backgroundImageView)
        //self.view.addSubview(self.shadeView)
        self.view.addSubview(self.logoButton)
        self.view.addSubview(self.emailTextField)
        self.view.addSubview(self.passwordTextField)
        self.view.addSubview(self.signInButton)
//        self.view.addSubview(self.facebookButton)
        self.view.addSubview(self.forgotPasswordButton)
        self.view.addSubview(self.signUpButton)
        self.view.addSubview(self.usernameTextField)
        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.registerUserButton)
        self.view.addSubview(self.getPasswordButton)
        self.view.addSubview(self.transparentView)
        self.view.addSubview(self.enterEmailLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:Notification.Name.UIKeyboardWillHide, object: nil)
        
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
        //imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var shadeView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Login logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var logoButton: UIButton = {
        let button: UIButton = UIButton()
        //button.setTitle("Sign up", for: .normal)
        button.addTarget(self, action: #selector(self.logoPressed), for: .touchUpInside)
        //button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "Login logo"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "logo_pressed"), for: .highlighted)
        button.addTarget(self, action: #selector(self.buttonHeldDown), for: .touchDown)
        button.addTarget(self, action: #selector(self.buttonLetGo), for: .touchDragExit)
        button.tag = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button: UIButton = UIButton()
        //button.setTitle("Sign up", for: .normal)
        button.addTarget(self, action: #selector(self.cancelPressed), for: .touchUpInside)
        //button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "realistic_back_button"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "realistic_back_button_pressed"), for: .highlighted)
        button.addTarget(self, action: #selector(self.buttonHeldDown), for: .touchDown)
        button.addTarget(self, action: #selector(self.buttonLetGo), for: .touchDragExit)
        button.tag = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    lazy var emailTextField: TIPTextField = {
        let textField: TIPTextField = TIPTextField(placeholder: "EMAIL", fontSize: self.fontSize)
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        textField.borderStyle = .none
        textField.background = #imageLiteral(resourceName: "Text Field")
        textField.delegate = self
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordTextField: TIPTextField = {
        let textField: TIPTextField = TIPTextField(placeholder: "PASSWORD", fontSize: self.fontSize)
        textField.textColor = UIColor.black
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.background = #imageLiteral(resourceName: "Text Field")
        textField.delegate = self
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var usernameTextField: TIPTextField = {
        let textField: TIPTextField = TIPTextField(placeholder: "USERNAME", fontSize: self.fontSize)
        textField.textColor = UIColor.black
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.background = #imageLiteral(resourceName: "Text Field")
        textField.delegate = self
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isHidden = true
        return textField
    }()
    
    lazy var signInButton: UIButton = {
        let button: UIButton = UIButton()
        //button.setTitle("Sign up", for: .normal)
        button.addTarget(self, action: #selector(self.signIn), for: .touchUpInside)
        //button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "login_button"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "login_pressed"), for: .highlighted)
        button.addTarget(self, action: #selector(self.buttonHeldDown), for: .touchDown)
        button.addTarget(self, action: #selector(self.buttonLetGo), for: .touchDragExit)
        button.tag = 1
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
    
    lazy var forgotPasswordButton: UIButton = {
        let button: UIButton = UIButton()
        //button.setTitle("Forgot password?", for: .normal)
        button.setImage(#imageLiteral(resourceName: "forgot_password"), for: .normal)
        button.addTarget(self, action: #selector(self.tappedForgotPasswordButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var signUpButton: UIButton = {
        let button: UIButton = UIButton()
        //button.setTitle("Sign up", for: .normal)
        button.addTarget(self, action: #selector(self.tappedSignUpButton), for: .touchUpInside)
        //button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "new_sign_up"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var registerUserButton: UIButton = {
        let button: UIButton = UIButton()
        //button.setTitle("Sign up", for: .normal)
        button.addTarget(self, action: #selector(self.signUp), for: .touchUpInside)
        //button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "register_button"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "sign_up_pressed"), for: .highlighted)
        button.addTarget(self, action: #selector(self.buttonHeldDown), for: .touchDown)
        button.addTarget(self, action: #selector(self.buttonLetGo), for: .touchDragExit)
        button.tag = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    lazy var getPasswordButton: UIButton = {
        let button: UIButton = UIButton()
        //button.setTitle("Sign up", for: .normal)
        button.addTarget(self, action: #selector(self.sendPassword), for: .touchUpInside)
        //button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "get_password"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "get_password_pressed"), for: .highlighted)
        button.addTarget(self, action: #selector(self.buttonHeldDown), for: .touchDown)
        button.addTarget(self, action: #selector(self.buttonLetGo), for: .touchDragExit)
        button.tag = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    lazy var enterEmailLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "font2", size: self.fontSize)
        label.textAlignment = .center
        label.text = "Enter your email address and\nwe will send you a link\nto reset your password"
        //label.backgroundColor = UIColor(white: 1, alpha: 0.5)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    lazy var transparentView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return view
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
        
//        self.shadeView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        self.shadeView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        self.shadeView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        self.shadeView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        //self.emailTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 140.0).isActive = true
        
        self.logoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.logoTop =  self.logoButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -self.view.frame.size.height/4)
        self.logoTop?.isActive = true
        //self.logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 35).isActive = true
        self.logoButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        self.logoButton.heightAnchor.constraint(equalTo: self.logoButton.widthAnchor).isActive = true
        
        
        emailTop = self.emailTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0)
        emailTop?.isActive = true
        self.emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //self.emailTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        //self.emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.emailTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        self.emailTextField.heightAnchor.constraint(equalToConstant: self.view.frame.size.height/15).isActive = true
        
        self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 10).isActive = true
        self.passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //self.emailTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        //self.emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.passwordTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: self.view.frame.size.height/15).isActive = true
        
        self.usernameTextField.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 10).isActive = true
        self.usernameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //self.emailTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        //self.emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.usernameTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        self.usernameTextField.heightAnchor.constraint(equalToConstant: self.view.frame.size.height/15).isActive = true
        
//        self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor).isActive = true
//        self.passwordTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
//        self.passwordTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
//        self.passwordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
//
        self.signInTop = self.signInButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.size.height/3)
        self.signInTop?.isActive = true
        self.signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.signInButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        self.signInButton.heightAnchor.constraint(equalTo: self.signInButton.widthAnchor, multiplier: 0.85).isActive = true
        
        self.signUpTop = self.registerUserButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.size.height/3)
        self.signUpTop?.isActive = true
        self.registerUserButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.registerUserButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        self.registerUserButton.heightAnchor.constraint(equalTo: self.registerUserButton.widthAnchor, multiplier: 0.85).isActive = true
        
        self.getPasswordTop = self.getPasswordButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.size.height/3)
        self.getPasswordTop?.isActive = true
        self.getPasswordButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.getPasswordButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        self.getPasswordButton.heightAnchor.constraint(equalTo: self.getPasswordButton.widthAnchor, multiplier: 0.85).isActive = true
        
//
//        self.facebookButton.topAnchor.constraint(equalTo: self.signInButton.bottomAnchor, constant: 20.0).isActive = true
//        self.facebookButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
//        self.facebookButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
//        self.facebookButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
//        
        self.forgotPasswordButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 5).isActive = true
        self.forgotPasswordButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.size.width/4).isActive = true
        self.forgotPasswordButton.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2).isActive = true
        self.forgotPasswordButton.widthAnchor.constraint(equalTo: self.forgotPasswordButton.heightAnchor, multiplier: 1.4).isActive = true
        
        self.signUpButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 10).isActive = true
        //self.signUpButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.size.height/2.5).isActive = true
        self.signUpButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -self.view.frame.size.width/5).isActive = true
        self.signUpButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.12).isActive = true
        self.signUpButton.widthAnchor.constraint(equalTo: self.signUpButton.heightAnchor, multiplier: 1.4).isActive = true
        
        self.cancelButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        cancelTop =  self.cancelButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -self.view.frame.size.height/4)
        self.cancelTop?.isActive = true
        self.cancelButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        self.cancelButton.heightAnchor.constraint(equalTo: self.cancelButton.widthAnchor).isActive = true
        
        self.enterEmailLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.enterEmailLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        
        self.transparentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.transparentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        self.transparentView.heightAnchor.constraint(equalTo: self.enterEmailLabel.heightAnchor).isActive = true
        self.transparentView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    func signIn() {
        self.signInTop?.constant = self.view.frame.size.height/3
        
        if self.emailTextField.text?.isEmpty == true || self.passwordTextField.text?.isEmpty == true {
            self.showAlert(title: "Please fill in all fields", message: nil, completion: nil)
        } else {
            let email: String = self.emailTextField.text!
            let password: String = self.passwordTextField.text!
            
            let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
            
            TIPAPIClient.logInUser(email: trimmedEmail, password: password, completionHandler: { (success: Bool) in
                if success == true {
                    
                    TIPAPIClient.getCurrentUserInfo(completionHandler: { (success: Bool) in
                        if success == true {
                            self.emailTextField.text = ""
                            self.passwordTextField.text = ""
                            self.view.endEditing(true)
                            TIPUser.currentUser?.backgroundPicSelection = self.backgoundPicSelection
                            TIPUser.currentUser?.save()
                            TIPAPIClient.connectToSendBird()
                            if let tabControl = AppDelegate.shared.tabBarController as? TIPTabBarController {
                                tabControl.splashView.isHidden = false
                                tabControl.splashView.alpha = 1.0
                            }
                            self.navigationController?.dismiss(animated: true, completion: {
                                
                            })
                            AppDelegate.shared.tabBarController?.selectedIndex = 0
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
    
    func signUp() {
        self.signUpTop?.constant = self.view.frame.size.height/3
        
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
                TIPAPIClient.connectToSendBird()
                self.navigationController?.dismiss(animated: true, completion: nil)
            } else {
                print("Could not register new user")
            }
        }
    }
    
    func sendPassword() {
        self.getPasswordTop?.constant = self.view.frame.size.height/3
        
        guard self.emailTextField.hasText == true else {
            self.showAlert(title: "Please fill in email field", message: nil, completion: nil)
            return
        }
        
        guard TIPValidator.isValidEmail(input: self.emailTextField.text!) == true else {
            self.showAlert(title: "Invalid email", message: nil, completion: nil)
            return
        }
        
        TIPAPIClient.forgotPassword(email: self.emailTextField.text!) { (success: Bool) in
            if success == true {
                self.showAlert(title: "Reset request submitted", message: "Please follow the instructions sent to your email") {
                    _ = self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                print("Forgot password error")
            }
        }
        
    }
    
    func logoPressed() {
        print("LOGO PRESSED")
        self.logoTop?.constant = -self.view.frame.size.height/4
        
        if self.backgoundPicSelection == 5 {
            self.backgoundPicSelection = 0
        } else {
            self.backgoundPicSelection = self.backgoundPicSelection + 1
        }
        
        self.backgroundImageView.image = TIPLoginViewController.backgroundPicArray[self.backgoundPicSelection]
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
        self.view.endEditing(true)
        emailTop?.constant += self.view.frame.size.height/6
        
        self.usernameTextField.isHidden = true
        self.signUpButton.isHidden = true
        self.forgotPasswordButton.isHidden = true
        self.signInButton.isHidden = true
        self.cancelButton.isHidden = false
        self.passwordTextField.isHidden = true
        self.getPasswordButton.isHidden = false
        self.enterEmailLabel.isHidden = false
        self.logoButton.isHidden = true
        self.transparentView.isHidden = false
        
        self.backgroundImageView.image = #imageLiteral(resourceName: "red_crumpled")
    }
    
    func tappedSignUpButton() {
        self.view.endEditing(true)
        
        self.usernameTextField.isHidden = false
        self.signUpButton.isHidden = true
        self.forgotPasswordButton.isHidden = true
        self.signInButton.isHidden = true
        self.cancelButton.isHidden = false
        self.registerUserButton.isHidden = false
        self.logoButton.isHidden = true
        
        self.backgroundImageView.image = #imageLiteral(resourceName: "blue_crumpled")
    }

    func buttonHeldDown(button: UIButton) {
        
        switch button.tag {
        case 0:
            self.logoTop?.constant += 5
        case 1:
            self.signInTop?.constant += 5
        case 2:
            self.cancelTop?.constant += 5
        case 3:
            self.signUpTop?.constant += 5
        case 4:
            self.getPasswordTop?.constant += 5
        default:
            break
        }
        
        
    }
    
    func buttonLetGo(button: UIButton) {
        
        switch button.tag {
        case 0:
            self.logoTop?.constant =  -self.view.frame.size.height/4
        case 1:
            self.signInTop?.constant = self.view.frame.size.height/3
        case 2:
            self.cancelTop?.constant = -self.view.frame.size.height/4
        case 3:
            self.signUpTop?.constant = self.view.frame.size.height/3
        case 4:
            self.getPasswordTop?.constant = self.view.frame.size.height/3
        default:
            break
        }
        
    }
    
    func cancelPressed() {
        cancelTop?.constant = -self.view.frame.size.height/4
        emailTop?.constant = 0
        
        self.usernameTextField.isHidden = true
        self.signUpButton.isHidden = false
        self.forgotPasswordButton.isHidden = false
        self.signInButton.isHidden = false
        self.cancelButton.isHidden = true
        self.passwordTextField.isHidden = false
        self.registerUserButton.isHidden = true
        self.getPasswordButton.isHidden = true
        self.enterEmailLabel.isHidden = true
        self.logoButton.isHidden = false
        self.transparentView.isHidden = true
        
        //self.backgoundPicSelection = 0
        self.backgroundImageView.image = TIPLoginViewController.backgroundPicArray[self.backgoundPicSelection]
    }
    
    func keyboardWillShow(sender: Notification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(sender: Notification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
        }
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
            
            TIPAPIClient.logInUser(email: email, password: id, completionHandler: { (success: Bool) in
                if success == true {
                    
                    TIPAPIClient.getCurrentUserInfo(completionHandler: { (success: Bool) in
                        if success == true {
                            //self.emailTextField.text = ""
                            //self.passwordTextField.text = ""
                            //self.view.endEditing(true)
                            TIPAPIClient.connectToSendBird()
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
