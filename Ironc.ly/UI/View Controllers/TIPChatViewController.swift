//
//  TIPChatViewController.swift
//  Ironc.ly
//
//  Created by Alex Laptop on 7/27/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit
import SendBirdSDK

class TIPChatViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let chatUser: TIPFeedItem
    let currentChannel: SBDGroupChannel
    let username: String?
    let chatReuseId: String = "iro.reuseId.chat"
    
    var messages = [SBDUserMessage]()
    
    // MARK: - View Lifecycle
    init(feedItem: TIPFeedItem, channel: SBDGroupChannel) {
        
        self.currentChannel = channel
        self.chatUser = feedItem
        self.username = feedItem.username
        
        super.init(collectionViewLayout: UICollectionViewFlowLayout())

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MYYYY ID: \(TIPUser.currentUser?.userId)")
        //self.view.isUserInteractionEnabled = true
        //self.collectionView?.isUserInteractionEnabled = false
        self.collectionView?.isScrollEnabled = true
        
        self.title = self.username
        self.collectionView?.backgroundColor = .white
        self.collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .black
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel"), style: .plain, target: self, action: #selector(self.tappedDismissButton))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(self.tappedBackButton))
        self.navigationController?.navigationBar.titleTextAttributes = TIPStyle.navBarTitleAttributes
        
        self.collectionView?.register(TIPChatCollectionViewCell.self, forCellWithReuseIdentifier: self.chatReuseId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:Notification.Name.UIKeyboardWillShow, object: nil);
       NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:Notification.Name.UIKeyboardWillHide, object: nil);
        
        self.view.addSubview(inputContainerView)
        self.inputContainerView.addSubview(sendButton)
        self.inputContainerView.addSubview(inputTextField)
        self.inputContainerView.addSubview(seperatorLine)
        
        self.setUpConstraints()
        
//        if chatUser.profileImage == nil {
//            UIImage.download(urlString: chatUser.profileImageURL, placeHolder: #imageLiteral(resourceName: "empty_profile")) { (image: UIImage?) in
//                self.chatUser.profileImage = image
//            }
//        }
        
        let messageQuery = self.currentChannel.createPreviousMessageListQuery()
        messageQuery?.loadPreviousMessages(withLimit: 30, reverse: false, completionHandler: { (oldMessages, error) in
            if error != nil {
                print("ERROR PULLING PREVIOUS MESSAGES: \(error)")
                return
            }
            
            if oldMessages?.count == 0 {
                print("NO MESSAGES")
                return
            }
            
            if let messes = oldMessages {
                
                print("OLD MESSAGES")
                
                for message in messes {
                    
                    let userMessage = message as! SBDUserMessage
                    self.messages.append(userMessage)
                    print("ID: \(userMessage.sender?.userId)")
                }
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
            
        
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //MARK: - LAZY VARIABLES
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        return containerView
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var seperatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    
    func setUpConstraints() {
        
        self.inputContainerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.inputContainerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.inputContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.inputContainerView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height/10).isActive = true
        
        self.sendButton.rightAnchor.constraint(equalTo: self.inputContainerView.rightAnchor).isActive = true
        self.sendButton.centerYAnchor.constraint(equalTo: self.inputContainerView.centerYAnchor).isActive = true
        self.sendButton.heightAnchor.constraint(equalTo: self.inputContainerView.heightAnchor).isActive = true
        self.sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.inputTextField.leftAnchor.constraint(equalTo: self.inputContainerView.leftAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: self.inputContainerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: self.sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: self.inputContainerView.heightAnchor).isActive = true
        
        self.seperatorLine.topAnchor.constraint(equalTo: self.inputContainerView.topAnchor).isActive = true
        self.seperatorLine.leftAnchor.constraint(equalTo: self.inputContainerView.leftAnchor).isActive = true
        self.seperatorLine.rightAnchor.constraint(equalTo: self.inputContainerView.rightAnchor).isActive = true
        self.seperatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    
    //MARK: - KEYBOARD
    func keyboardWillShow(sender: Notification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(sender: Notification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.inputTextField.endEditing(true)
    }
    
    //MARK: - BUTTON ACTIONS
    func tappedBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendPressed() {
        
        if inputTextField.text?.isEmpty == true {
            print("NO TEXT")
            return
        }
        
        let message = inputTextField.text!
       
        self.inputTextField.endEditing(true)
        self.inputTextField.text = ""
        
        self.currentChannel.sendUserMessage(message) { (newMessage, error) in
            
             self.messages.append(newMessage!)
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }

    }
    
    
    //MARK: - COLLECTION VIEW
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TIPChatCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.chatReuseId, for: indexPath) as! TIPChatCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.sender?.userId == TIPUser.currentUser?.userId {
            cell.bubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true
            
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
        } else {
            cell.bubbleView.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
            cell.textView.textColor = .black
            //cell.profileImageView.image = chatUser.profileImage
            cell.profileImageView.isHidden = false
            
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
        }
        
        if let profileURL = chatUser.profileImageURL {
            cell.profileImageView.loadImageUsingCacheFromUrlString(urlString: profileURL, placeHolder: UIImage(named: "empty_profile")!) {}
        } else {
            cell.profileImageView.loadImageUsingCacheFromUrlString(urlString: "no image", placeHolder: UIImage(named: "empty_profile")!) {}
        }
        
        cell.textView.text = message.message
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.message!).width + 32
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        let text = messages[indexPath.item]
        height = estimateFrameForText(text: text.message!).height + 20
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}
