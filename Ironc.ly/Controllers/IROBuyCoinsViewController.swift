//
//  IROBuyCoinsViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 5/25/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit
import StoreKit

class IROBuyCoinsViewController: UIViewController {
    
    // MARK: - Properties
    var coins: Int = UserDefaults.standard.integer(forKey: "coins")
    var productsRequest = SKProductsRequest()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        self.view.addSubview(self.coinsLabel)
        self.view.addSubview(self.coins1000Button)
        self.view.addSubview(self.coins2000Button)
        self.view.addSubview(self.coins5000Button)
        self.view.addSubview(self.coins10000Button)
        
        self.coinsLabel.text = "\(self.coins) coins"
        
        self.setUpConstraints()
        
        self.getAvailableProducts()
    }
    
    // MARK: - Layout
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.coins1000Button.layer.cornerRadius = self.coins1000Button.frame.size.height / 2.0
        self.coins2000Button.layer.cornerRadius = self.coins2000Button.frame.size.height / 2.0
        self.coins5000Button.layer.cornerRadius = self.coins5000Button.frame.size.height / 2.0
        self.coins10000Button.layer.cornerRadius = self.coins10000Button.frame.size.height / 2.0
    }
    
    // MARK: - Lazy Initialization
    class IROCoinsButton: IROButton {
        var coins: Int?
    }
    
    lazy var coinsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 30.0, weight: UIFontWeightHeavy)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var coins1000Button: IROCoinsButton = {
        let button: IROCoinsButton = IROCoinsButton(style: .green)
        button.coins = 1000
        button.setTitle("Buy 1,000 coins", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var coins2000Button: IROCoinsButton = {
        let button: IROCoinsButton = IROCoinsButton(style: .green)
        button.coins = 2000
        button.setTitle("Buy 2,000 coins", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var coins5000Button: IROButton = {
        let button: IROCoinsButton = IROCoinsButton(style: .green)
        button.coins = 5000
        button.setTitle("Buy 5,000 coins", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var coins10000Button: IROButton = {
        let button: IROCoinsButton = IROCoinsButton(style: .green)
        button.coins = 10000
        button.setTitle("Buy 10,000 coins", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var priceFormatter: NumberFormatter = {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        return formatter
    }()

    
    // MARK: - Autolayout
    func setUpConstraints() {
        
        let hMargin: CGFloat = 50.0
        let vMargin: CGFloat = 20.0
        let buttonHeight: CGFloat = 50.0
        
        self.coinsLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100.0).isActive = true
        self.coinsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.coinsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.coins1000Button.topAnchor.constraint(equalTo: self.coinsLabel.bottomAnchor, constant: 100.0).isActive = true
        self.coins1000Button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.coins1000Button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.coins1000Button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        self.coins2000Button.topAnchor.constraint(equalTo: self.coins1000Button.bottomAnchor, constant: vMargin).isActive = true
        self.coins2000Button.leftAnchor.constraint(equalTo: self.coins1000Button.leftAnchor).isActive = true
        self.coins2000Button.rightAnchor.constraint(equalTo: self.coins1000Button.rightAnchor).isActive = true
        self.coins2000Button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        self.coins5000Button.topAnchor.constraint(equalTo: self.coins2000Button.bottomAnchor, constant: vMargin).isActive = true
        self.coins5000Button.leftAnchor.constraint(equalTo: self.coins2000Button.leftAnchor).isActive = true
        self.coins5000Button.rightAnchor.constraint(equalTo: self.coins2000Button.rightAnchor).isActive = true
        self.coins5000Button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        self.coins10000Button.topAnchor.constraint(equalTo: self.coins5000Button.bottomAnchor, constant: vMargin).isActive = true
        self.coins10000Button.leftAnchor.constraint(equalTo: self.coins5000Button.leftAnchor).isActive = true
        self.coins10000Button.rightAnchor.constraint(equalTo: self.coins5000Button.rightAnchor).isActive = true
        self.coins10000Button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }
    
    func tappedCoinsButton(sender: IROCoinsButton) {
        guard let coins: Int = sender.coins else { return }
        
        let productId: String = "com.premiumsnap.coins.\(coins)"
        
    }
    
    func getAvailableProducts() {
        let productIds: Set<String> = ["com.premiumsnap.coins.1000"]
        let productsRequest = SKProductsRequest(productIdentifiers: productIds)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func purchase(product: SKProduct) {

    }

}

extension IROBuyCoinsViewController: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product: SKProduct in response.products {
            if product.productIdentifier == "com.premiumsnap.coins.1000" {
                self.priceFormatter.locale = product.priceLocale
                if let price: String = self.priceFormatter.string(from: product.price) {
                    let buyTitle: String = "Buy 1,000 coins - \(price)"
                    self.coins1000Button.setTitle(buyTitle, for: .normal)
                }
            }
        }
    }
    
}

extension IROBuyCoinsViewController: SKPaymentTransactionObserver {
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        //
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
        //
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        //
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        //
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //
    }
    
}
