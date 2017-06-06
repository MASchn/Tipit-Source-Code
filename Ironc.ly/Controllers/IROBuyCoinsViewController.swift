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
    var products: [IROProduct] = []
    
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
        tableView.register(IROCoinTableViewCell.self, forCellReuseIdentifier: self.coinsReuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var priceFormatter: NumberFormatter = {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        return formatter
    }()

    
    // MARK: - Autolayout
    func setUpConstraints() {
        
        self.coinsLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100.0).isActive = true
        self.coinsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.coinsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.coinsTableView.topAnchor.constraint(equalTo: self.coinsLabel.bottomAnchor, constant: 50.0).isActive = true
        self.coinsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.coinsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.coinsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
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

    }

}

extension IROBuyCoinsViewController: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        var products: [IROProduct] = response.products.map { (product: SKProduct) -> IROProduct in
            self.priceFormatter.locale = product.priceLocale
            let id: NSString = product.productIdentifier as NSString
            let coins: String = id.components(separatedBy: ".").last!
            let coinsNumber: Int = Int(coins)!
            let price: String = self.priceFormatter.string(from: product.price)!
            return IROProduct(
                coins: coinsNumber,
                price: price
            )
        }
        products.sort {
            return $0.coins < $1.coins
        }
        self.products = products
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
        let product: IROProduct = self.products[indexPath.row]
        cell.configure(with: product)
        return cell
    }
    
}

extension IROBuyCoinsViewController: UITableViewDelegate {
    
}
