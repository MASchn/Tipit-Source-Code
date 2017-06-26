//
//  IROPlaceholderViewController.swift
//  Ironc.ly
//

import UIKit

class IROPlaceholderViewController: UIViewController {

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.green

        self.view.addSubview(self.placeholderLabel)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.placeholderLabel.frame = self.view.bounds
    }
    
    // MARK: - Lazy Initialization
    lazy var placeholderLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 36.0)
        label.textAlignment = .center
        return label
    }()


}
