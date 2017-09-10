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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        //self.navigationController.to
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.addSubview(myWalletImageView)
        self.view.addSubview(coinsImageView)
        self.view.addSubview(buyCoinsButton)
        self.view.addSubview(coinsLabel)
        self.view.addSubview(coinsEarnedLabel)
        
        self.configureTIPNavBar()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel"), style: .plain, target: self, action: #selector(self.tappedBackButton))
        self.addPullDownMenu()
        self.setUpWalletConstraints()

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedBackButton() {

        dismiss(animated: true, completion: nil)
    }


    lazy var myWalletImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        //imageView.contentMode = .scaleAspectFill
        //imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "my_wallet")
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
        button.setImage(#imageLiteral(resourceName: "buy_coins"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "pressed_buy_coins"), for: .highlighted)
//        button.addTarget(self, action: #selector(self.buyCoinsTapped), for: .touchUpInside)
//        button.addTarget(self, action: #selector(self.buyCoinsHeldDown), for: .touchDown)
//        button.addTarget(self, action: #selector(self.buyCoinsLetGo), for: .touchDragExit)
        //button.imageView?.contentMode = .scaleAspectFill
        //button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var coinsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        //label.textColor = .white
//        label.font = UIFont(name: AppDelegate.shared.fontName, size: self.fontSize)
        label.text = "Coins: 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var coinsEarnedLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        //label.textColor = .white
//        label.font = UIFont(name: AppDelegate.shared.fontName, size: self.fontSize)
        label.text = "Earned: 0"
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
        
        self.myWalletImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 25).isActive = true
        self.myWalletImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.myWalletImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.myWalletImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.myWalletImageView.heightAnchor.constraint(equalTo: self.myWalletImageView.widthAnchor, multiplier: 0.3).isActive = true
        
        self.coinsImageView.topAnchor.constraint(equalTo: self.myWalletImageView.bottomAnchor, constant: 50).isActive = true
        self.coinsImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.coinsImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3).isActive = true
        self.coinsImageView.widthAnchor.constraint(equalTo: self.coinsImageView.heightAnchor, constant: 0).isActive = true
        
        self.coinsLabel.topAnchor.constraint(equalTo: self.coinsImageView.topAnchor, constant: 25).isActive = true
        self.coinsLabel.leftAnchor.constraint(equalTo: self.coinsImageView.rightAnchor, constant: 25).isActive = true
        
        self.coinsEarnedLabel.topAnchor.constraint(equalTo: self.coinsLabel.bottomAnchor, constant: 25).isActive = true
        self.coinsEarnedLabel.leftAnchor.constraint(equalTo: self.coinsLabel.leftAnchor, constant: 0).isActive = true
        
        
        self.buyCoinsButton.topAnchor.constraint(equalTo: self.coinsImageView.bottomAnchor, constant: 50).isActive = true
        self.buyCoinsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.buyCoinsButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        self.buyCoinsButton.heightAnchor.constraint(equalTo: self.buyCoinsButton.widthAnchor, multiplier: 1).isActive = true
        
        
    }
    
    
}
