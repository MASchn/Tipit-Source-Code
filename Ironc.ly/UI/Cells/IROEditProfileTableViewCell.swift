//
//  IROEditProfileTableViewCell.swift
//  Ironc.ly
//

import UIKit

protocol IROEditProfileCellDelegate: class {
    func finishedTyping(cell: IROEditProfileTableViewCell)
}

class IROEditProfileTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    weak var delegate: IROEditProfileCellDelegate?
    
    // MARK: - View Lifecycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.textField)
        
        self.setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lazy Initialization
    lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: UIFontWeightBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField: UITextField = UITextField()
        textField.font = .systemFont(ofSize: 15.0, weight: UIFontWeightRegular)
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10.0).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20.0).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        
        self.textField.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor).isActive = true
        self.textField.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20.0).isActive = true
        self.textField.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.textField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10.0).isActive = true
    }

}

extension IROEditProfileTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.finishedTyping(cell: self)
        
        return false
    }
    
}
