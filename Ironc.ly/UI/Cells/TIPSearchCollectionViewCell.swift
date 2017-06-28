//
//  TIPSearchCollectionViewCell.swift
//  Ironc.ly
//

import UIKit

protocol TIPSearchCollectionViewCellDelegate: class {
    func searchCellDidSelectUser(with userId: String)
}

class TIPSearchCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    var userId: String?
    weak var delegate: TIPSearchCollectionViewCellDelegate?
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.postImageView)
        self.contentView.addSubview(self.profileButton)
        self.contentView.addSubview(self.usernameLabel)
        self.contentView.addSubview(self.profileImageView)
        
        self.setUpConstraints()
        self.contentView.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.profileImageView.image = nil
    }
    
    func configure(with searchUser: TIPSearchUser) {
        self.userId = searchUser.userId
        
        self.usernameLabel.text = searchUser.username
        
        UIImage.download(urlString: searchUser.profileImageURL, completion: { (image: UIImage?) in
            self.profileImageView.image = image
        })
        
        UIImage.download(urlString: searchUser.mediaItemURL, completion: { (image: UIImage?) in
            self.postImageView.image = image
        })
        
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2.0
    }
    
    // MARK: - Lazy Initialization
    lazy var postImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Invisible button for hit area behind profile image view and username label to go to profile
    lazy var profileButton: UIButton = {
        let button: UIButton = UIButton()
        button.addTarget(self, action: #selector(self.tappedProfileButton(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var usernameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12.0, weight: UIFontWeightHeavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        let hMargin: CGFloat = 10.0
        let vMargin: CGFloat = 10.0
        
        self.postImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.postImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.postImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.postImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        
        self.usernameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: vMargin).isActive = true
        self.usernameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: hMargin).isActive = true
        self.usernameLabel.rightAnchor.constraint(lessThanOrEqualTo: self.contentView.rightAnchor, constant: -hMargin).isActive = true
        self.usernameLabel.rightAnchor.constraint(greaterThanOrEqualTo: self.profileImageView.rightAnchor, constant: hMargin).isActive = true
        
        self.profileImageView.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: vMargin).isActive = true
        self.profileImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: hMargin).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        self.profileButton.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.profileButton.bottomAnchor.constraint(equalTo: self.profileImageView.bottomAnchor).isActive = true
        self.profileButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.profileButton.rightAnchor.constraint(equalTo: self.usernameLabel.rightAnchor, constant: hMargin).isActive = true
    }
    
    // MARK: - Actions
    func tappedProfileButton(sender: UIButton) {
        if let userId: String = self.userId {
            self.delegate?.searchCellDidSelectUser(with: userId)
        }
    }
    
}
