//
//  TIPWalletViewController.swift
//  Ironc.ly
//
//  Created by Maxwell Schneider on 9/8/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class TIPWalletViewController: TIPViewControllerWIthPullDown {
    
    var buyCoinsTop: NSLayoutConstraint?
    var fontSize: CGFloat = 18.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        //self.navigationController.to
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let screen = UIScreen.main
        self.fontSize = screen.bounds.size.height * (18.0 / 568.0)
        if (screen.bounds.size.height < 500) {
            self.fontSize = screen.bounds.size.height * (18.0 / 480.0)
        }
        
//        TIPLoginViewController.backgroundPicArray
        
      //  self.backgroundImageView.image = TIPLoginViewController.backgroundPicArray[TIPUser.currentUser?.backgroundPicSelection ?? 0]
        self.view.addSubview(userBackgroundImageView)
        self.view.addSubview(walletBackgroundImageView)
        self.view.addSubview(myWalletImageView)
//        self.view.addSubview(coinsImageView)
        self.view.addSubview(buyCoinsButton)
        self.view.addSubview(coinsLabel)
        self.view.addSubview(fancyDividerLine)
        self.view.addSubview(coinsEarnedLabel)
        self.view.addSubview(cashOutButton)
        self.view.addSubview(coinsSpentLabel)
        self.view.addSubview(availableBalanceLabel)
        self.userBackgroundImageView.image = TIPLoginViewController.backgroundPicArray[TIPUser.currentUser?.backgroundPicSelection ?? 0]

        
        self.configureTIPNavBar()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel"), style: .plain, target: self, action: #selector(self.tappedBackButton))
        self.addPullDownMenu()
        self.setUpWalletConstraints()

        self.populateLabels()
        
        
    }
    
    func populateLabels(){
        
        self.coinsLabel.text = "-COINS- \n \(TIPUser.currentUser?.coins ?? 0)"
        self.coinsEarnedLabel.text = "-TOTAL EARNED- \n \(TIPUser.currentUser?.coinsEarned ?? 0)"
        self.coinsSpentLabel.text = "-TOTAL SPENT- \n 0"
        self.availableBalanceLabel.text = "-AVAILABLE BALANCE- \n 0"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedBackButton() {

        dismiss(animated: true, completion: nil)
    }
    
    lazy var userBackgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        //imageView.contentMode = .scaleAspectFill
        //imageView.clipsToBounds = true
        imageView.image = UIImage()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()


    lazy var walletBackgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        //imageView.contentMode = .scaleAspectFill
        //imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "WalletBackground")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var fancyDividerLine: UIImageView = {
        let thisImageView: UIImageView = UIImageView()
        //imageView.contentMode = .scaleAspectFill
        //imageView.clipsToBounds = true
        thisImageView.image = #imageLiteral(resourceName: "FancyDivider")
        thisImageView.translatesAutoresizingMaskIntoConstraints = false
        return thisImageView
    }()


    
    lazy var myWalletImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        //imageView.contentMode = .scaleAspectFill
        //imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "NormalWallet")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var coinsImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        //imageView.contentMode = .scaleAspectFill
        //imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "coin_stack")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var buyCoinsButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "GetMoreCoinsDepressed"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "GetMoreCoinsPressed"), for: .highlighted)
        button.addTarget(self, action: #selector(self.buyCoinsTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cashOutButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "CashOutDepressed"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "CashOutPressed"), for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    //CHANGE FONT SIZE AND TEXT LABELING TO FIT ENTIRELY WITHIN THE SCREWS BOX
    
    lazy var coinsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2

        //label.textColor = .white
        label.font = UIFont(name: AppDelegate.shared.fontName, size: self.fontSize)
        label.text = "-COINS- \n 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var coinsEarnedLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        //label.textColor = .white
        label.font = UIFont(name: AppDelegate.shared.fontName, size: self.fontSize)
        label.text = "-TOTAL EARNED- \n 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var coinsSpentLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        //label.textColor = .white
                label.font = UIFont(name: AppDelegate.shared.fontName, size: self.fontSize)
        label.text = "-TOTAL SPENT- \n 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var availableBalanceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        //label.textColor = .white
                label.font = UIFont(name: AppDelegate.shared.fontName, size: self.fontSize - 1 )
        label.text = "-AVAILABLE BALANCE- \n 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    
    func buyCoinsTapped() {
        let buyCoinsViewController: TIPBuyCoinsViewController = TIPBuyCoinsViewController(style: .grouped)
        //buyCoinsViewController.delegate = self
        let navigationController: UINavigationController = UINavigationController(rootViewController: buyCoinsViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func buyCoinsHeldDown() {
        self.buyCoinsTop?.constant += 5
    }
    
    func buyCoinsLetGo() {
        self.buyCoinsTop?.constant = 20
    }
    

    func setUpWalletConstraints() {
        
        
        self.userBackgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.userBackgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.userBackgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.userBackgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        self.walletBackgroundImageView.topAnchor.constraint(equalTo: self.myWalletImageView.bottomAnchor, constant: 15).isActive = true
        self.walletBackgroundImageView.leftAnchor.constraint(equalTo: self.myWalletImageView.leftAnchor, constant: 0).isActive = true
        self.walletBackgroundImageView.rightAnchor.constraint(equalTo: self.myWalletImageView.rightAnchor, constant: 0).isActive = true
        //FIX THIS SHIT LATER
        self.walletBackgroundImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.35).isActive = true
//        self.walletBackgroundImageView.bottomAnchor.constraint(equalTo: self.fancyDividerLine.topAnchor, constant: 20).isActive = true
        
        self.myWalletImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
//        self.myWalletImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        self.myWalletImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.myWalletImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        self.myWalletImageView.heightAnchor.constraint(equalTo: self.myWalletImageView.widthAnchor, multiplier: 0.7).isActive = true
        self.myWalletImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
//        self.coinsImageView.topAnchor.constraint(equalTo: self.myWalletImageView.bottomAnchor, constant: 50).isActive = true
//        self.coinsImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
//        self.coinsImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3).isActive = true
//        self.coinsImageView.widthAnchor.constraint(equalTo: self.coinsImageView.heightAnchor, constant: 0).isActive = true
        
        self.coinsLabel.topAnchor.constraint(equalTo: self.walletBackgroundImageView.topAnchor, constant: 10).isActive = true
//        self.coinsLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        self.coinsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
//        self.coinsLabel.leftAnchor.constraint(equalTo: self.coinsImageView.rightAnchor, constant: 25).isActive = true
        
        self.coinsEarnedLabel.topAnchor.constraint(equalTo: self.coinsLabel.bottomAnchor, constant: 10).isActive = true
        self.coinsEarnedLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
//        self.coinsEarnedLabel.leftAnchor.constraint(equalTo: self.coinsLabel.leftAnchor, constant: 0).isActive = true
        
        self.coinsSpentLabel.topAnchor.constraint(equalTo: self.coinsEarnedLabel.bottomAnchor, constant: 10).isActive = true
        self.coinsSpentLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        self.availableBalanceLabel.topAnchor.constraint(equalTo: self.coinsSpentLabel.bottomAnchor, constant: 10).isActive = true
        self.availableBalanceLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        
        self.buyCoinsButton.topAnchor.constraint(equalTo: self.walletBackgroundImageView.bottomAnchor, constant: 25).isActive = true
        self.buyCoinsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.buyCoinsButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        self.buyCoinsButton.heightAnchor.constraint(equalTo: self.buyCoinsButton.widthAnchor, multiplier: 0.27
            ).isActive = true
//        self.buyCoinsButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
//        self.buyCoinsButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        
        self.fancyDividerLine.topAnchor.constraint(equalTo: self.buyCoinsButton.bottomAnchor, constant: 0).isActive = true
        self.fancyDividerLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.fancyDividerLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.35).isActive = true
        self.fancyDividerLine.heightAnchor.constraint(equalTo: self.fancyDividerLine.widthAnchor, multiplier: 0.3).isActive = true
        
        self.cashOutButton.topAnchor.constraint(equalTo: self.fancyDividerLine.bottomAnchor, constant: 0).isActive = true
//        self.cashOutButton.leftAnchor.constraint(equalTo: self.myWalletImageView.leftAnchor, constant: 0).isActive = true
//        self.cashOutButton.rightAnchor.constraint(equalTo: self.myWalletImageView.rightAnchor, constant: 0).isActive = true
        self.cashOutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.cashOutButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.65).isActive = true
        self.cashOutButton.heightAnchor.constraint(equalTo: self.cashOutButton.widthAnchor, multiplier: 0.27).isActive = true

        
    }
    
    
}
