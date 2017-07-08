//
//  TIPBuyCoinsViewController.swift
//  Ironc.ly
//

import UIKit
import StoreKit

struct TIPProduct {
    let coins: Int
    let price: String
}

protocol TIPBuyCoinsViewControllerDelegate: class {
    func buyCoinsViewControllerDidDismiss()
}

class TIPBuyCoinsViewController: UITableViewController {
    
    // MARK: - Properties
    var productsRequest = SKProductsRequest()
    let coinsReuseId: String = "iro.reuseId.coins"
    var products: [SKProduct] = []
    weak var delegate: TIPBuyCoinsViewControllerDelegate?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.coinsLabel)
        
        let coins: Int = UserDefaults.standard.integer(forKey: "coins")
        let formattedCoins: String = TIPCoinsFormatter.formattedCoins(coins: coins)
        self.coinsLabel.text = formattedCoins + " coins"
        
        self.tableView.tableHeaderView = self.coinsLabel
        self.tableView.alwaysBounceVertical = true
        self.tableView.rowHeight = 64.0
        self.tableView.register(TIPCoinTableViewCell.self, forCellReuseIdentifier: self.coinsReuseId)
        
        self.getAvailableProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "My Coins"
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = TIPStyle.navBarTitleAttributes
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel"), style: .plain, target: self, action: #selector(self.tappedDismissButton))
    }
    
    // MARK: - Lazy Initialization
    lazy var coinsLabel: UILabel = {
        let label: UILabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 120.0))
        label.font = .systemFont(ofSize: 30.0, weight: UIFontWeightHeavy)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        guard let user: TIPUser = TIPUser.currentUser else { return }

        self.showAlert(title: "Buy coins", message: product.productIdentifier) {
            guard let user: TIPUser = TIPUser.currentUser else { return }
            let coins: Int = TIPCoinsFormatter.coins(productIdentifier: product.productIdentifier)
            let newCoins: Int = user.coins + coins
            user.coins = newCoins
            user.updateCoins(newAmount: newCoins)
            let formattedCoins: String = TIPCoinsFormatter.formattedCoins(coins: newCoins)
            self.coinsLabel.text = formattedCoins + " coins"
            
            // TODO: Shouldn't have to know about API fields here. Refactorable.
            let parameters: [String: Any] = [
                "coins" : user.coins
            ]
            
            TIPAPIClient.updateUser(parameters: parameters, completionHandler: { (success: Bool) in
                // TODO: Success and error handling
            })
        }
        
//        let payment: SKPayment = SKPayment(product: product)
//        SKPaymentQueue.default().add(payment)
    }
    
    func tappedDismissButton() {
        self.dismiss(animated: true) { 
            self.delegate?.buyCoinsViewControllerDidDismiss()
        }
    }

}

extension TIPBuyCoinsViewController: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        var products = response.products
        products.sort {
            CGFloat($0.price) < CGFloat($1.price)
        }
        self.products = products
        self.tableView.reloadData()
    }
    
}

extension TIPBuyCoinsViewController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                self.complete(transaction: transaction)
            case .failed:
                break
            case .restored:
                break
            case .deferred:
                break
            default:
                break
            }
        }
    }
    
    func complete(transaction: SKPaymentTransaction) {
        guard let user: TIPUser = TIPUser.currentUser else { return }

        let productId: String = transaction.payment.productIdentifier
        let coins = TIPCoinsFormatter.coins(productIdentifier: productId)
        user.coins += coins
        self.coinsLabel.text = "\(user.coins) coins"
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TIPCoinTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.coinsReuseId) as! TIPCoinTableViewCell
        let product: SKProduct = self.products[indexPath.row]
        cell.configure(with: product)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let product: SKProduct = self.products[indexPath.row]
        self.purchase(product: product)
    }
    
}
