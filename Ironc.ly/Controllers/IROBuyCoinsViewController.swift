//
//  IROBuyCoinsViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 5/25/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit
import StoreKit

struct IROProduct {
    let coins: Int
    let price: String
}

class IROBuyCoinsViewController: UIViewController {
    
    // MARK: - Properties
    var coins: Int = UserDefaults.standard.integer(forKey: "coins")
    var productsRequest = SKProductsRequest()
    let coinsReuseId: String = "iro.reuseId.coins"
    var products: [SKProduct] = []
    
    lazy var tableViewHeight: CGFloat = CGFloat(self.products.count) * self.coinsTableView.rowHeight
    lazy var tableViewHeightConstraint: NSLayoutConstraint = self.coinsTableView.heightAnchor.constraint(equalToConstant: 0.0)
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .groupTableViewBackground

        self.view.addSubview(self.coinsLabel)
        self.view.addSubview(self.coinsTableView)
        
        self.coinsLabel.text = "\(self.coins) coins"
        
        self.setUpConstraints()
        
        self.getAvailableProducts()
    }
    
    // MARK: - Lazy Initialization
    lazy var coinsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 30.0, weight: UIFontWeightHeavy)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var coinsTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.backgroundColor = .white
        tableView.alwaysBounceVertical = true
        tableView.rowHeight = 64.0
        tableView.register(IROCoinTableViewCell.self, forCellReuseIdentifier: self.coinsReuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.coinsLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100.0).isActive = true
        self.coinsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.coinsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.coinsTableView.topAnchor.constraint(equalTo: self.coinsLabel.bottomAnchor, constant: 50.0).isActive = true
        self.coinsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.coinsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableViewHeightConstraint.isActive = true
    }
    
    func getAvailableProducts() {
        let productIds: Set<String> = [
            "com.premiumsnap.coins.1000",
            "com.premiumsnap.coins.1200",
            "com.premiumsnap.coins.1500",
            "com.premiumsnap.coins.4000",
            "com.premiumsnap.coins.10000",
            "com.premiumsnap.coins.70000"
        ]
        let productsRequest = SKProductsRequest(productIdentifiers: productIds)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func purchase(product: SKProduct) {
        let payment: SKPayment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

}

extension IROBuyCoinsViewController: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        var products = response.products
        products.sort {
            CGFloat($0.price) < CGFloat($1.price)
        }
        self.products = products
        self.tableViewHeightConstraint.constant = self.tableViewHeight
        self.coinsTableView.reloadData()
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

extension IROBuyCoinsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: IROCoinTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.coinsReuseId) as! IROCoinTableViewCell
        let product: SKProduct = self.products[indexPath.row]
        cell.configure(with: product)
        return cell
    }
    
}

extension IROBuyCoinsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let product: SKProduct = self.products[indexPath.row]
        self.purchase(product: product)
    }
    
}
