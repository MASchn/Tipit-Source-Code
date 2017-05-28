//
//  IROTipView.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 5/26/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

protocol IROTipViewDelegate: class {
    func tipView(view: IROTipView, didSelectCloseButton button: UIButton)
}

class IROTipView: UIView {
    
    // MARK: - Properties
    weak var delegate: IROTipViewDelegate?
    let shapeReuseId: String = "iro.reuseId.shape"
    let images: [UIImage] = [#imageLiteral(resourceName: "crown"), #imageLiteral(resourceName: "diamond"), #imageLiteral(resourceName: "flame"), #imageLiteral(resourceName: "heart"), #imageLiteral(resourceName: "lips"), #imageLiteral(resourceName: "smile"), #imageLiteral(resourceName: "star"), #imageLiteral(resourceName: "sun")]
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.shadeView)
        self.addSubview(self.closeButton)
        self.addSubview(self.timeLabel)
        self.addSubview(self.coinsLabel)
        self.addSubview(self.shapesCollectionView)
        
        self.setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lazy Initialization
    lazy var shadeView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(self.tappedCloseButton(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var timeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36.0, weight: UIFontWeightHeavy)
        label.text = "+ 20 mins"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var coinsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24.0, weight: UIFontWeightMedium)
        label.text = "50 coins"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var shapesCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(IROShapeCollectionViewCell.self, forCellWithReuseIdentifier: self.shapeReuseId)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.shadeView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.shadeView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.shadeView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.shadeView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        self.closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 50.0).isActive = true
        self.closeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.closeButton.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        self.closeButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        self.timeLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -50.0).isActive = true
        self.timeLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        self.coinsLabel.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 20.0).isActive = true
        self.coinsLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.coinsLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        self.shapesCollectionView.topAnchor.constraint(equalTo: self.coinsLabel.bottomAnchor, constant: 20.0).isActive = true
        self.shapesCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.shapesCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.shapesCollectionView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scaleCells()
    }
    
    let minScale: CGFloat = 0.5
    let maxScale: CGFloat = 1.0
    
    func scaleCells() {
        for cell in self.shapesCollectionView.visibleCells {
            let distanceFromCenter: CGFloat = abs(self.shapesCollectionView.bounds.width / 2.0 - (cell.frame.midX - self.shapesCollectionView.contentOffset.x))
            
            let minBound: CGFloat = 50.0
            let maxBound: CGFloat = 200.0
            
            if distanceFromCenter < minBound {
                cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            } else if distanceFromCenter >= minBound && distanceFromCenter <= maxBound {
                let scale: CGFloat = maxScale - ((distanceFromCenter - minBound) / (maxBound - minBound)) * (self.maxScale - self.minScale)
                cell.transform = CGAffineTransform(scaleX: scale, y: scale)
            } else {
                cell.transform = CGAffineTransform(scaleX: minScale, y: minScale)
            }
            
        }
    }

    // MARK: - Actions
    func tappedCloseButton(sender: UIButton) {
        self.delegate?.tipView(view: self, didSelectCloseButton: sender)
    }
    
}

extension IROTipView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: IROShapeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.shapeReuseId, for: indexPath) as! IROShapeCollectionViewCell
        let image: UIImage = self.images[indexPath.item]
        cell.shapeImageView.image = image
        return cell
    }
    
}

extension IROTipView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150.0, height: 150.0)
    }
    
}
