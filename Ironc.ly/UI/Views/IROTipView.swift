//
//  IROTipView.swift
//  Ironc.ly
//

import UIKit

protocol IROTipViewDelegate: class {
    func tipView(view: IROTipView, didSelectCloseButton button: UIButton)
    func tipView(view: IROTipView, didSelectBuyCoinsButton button: UIButton)
    func tipView(view: IROTipView, didSelectShape shape: IROShape)
}

class IROTipView: UIView {
    
    // MARK: - Properties
    weak var delegate: IROTipViewDelegate?
    let shapeReuseId: String = "iro.reuseId.shape"
    
    // Add buffer space to front and back by adding blank images
    let startBuffer: IROShape = IROShape()
    let crown: IROShape = IROShape(name: "crown", minutes: 20, coins: 50)
    let flame: IROShape = IROShape(name: "flame", minutes: 60, coins: 150)
    let diamond: IROShape = IROShape(name: "diamond", minutes: 20, coins: 100)
    let heart: IROShape = IROShape(name: "heart", minutes: 40, coins: 200)
    let kiss: IROShape = IROShape(name: "kiss", minutes: 60, coins: 300)
    let smile: IROShape = IROShape(name: "smile", minutes: 80, coins: 400)
    let sun: IROShape = IROShape(name: "sun", minutes: 100, coins: 500)
    let endBuffer: IROShape = IROShape()
    
    lazy var shapes: [IROShape] = [self.startBuffer, self.diamond, self.heart, self.kiss, self.smile, self.sun, self.endBuffer]
    
    // Update the labels when a new shape is closest to center
    var closestToCenterIndex: Int = 0 {
        didSet {
            let shape: IROShape = self.shapes[closestToCenterIndex]
            if shape.name != nil {
                self.timeLabel.text = "\(shape.minutes) minutes"
                self.coinsLabel.text = "\(shape.coins) coins"
            }
        }
    }
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.closeButton)
        self.addSubview(self.timeLabel)
        self.addSubview(self.coinsLabel)
        self.addSubview(self.shapesCollectionView)
        self.addSubview(self.buyCoinsButton)
        
        self.setUpConstraints()
        self.layoutIfNeeded()
        
        // Hacky but necessary to scale cells upon first load
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.scaleCells()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.buyCoinsButton.layer.cornerRadius = self.buyCoinsButton.frame.size.height / 2.0
    }
    
    // MARK: - Lazy Initialization
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
    
    lazy var buyCoinsButton: IROButton = {
        let button: IROButton = IROButton(style: .green)
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: UIFontWeightMedium)
        button.addTarget(self, action: #selector(self.tappedBuyCoinsButton(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var shapesCollectionView: UICollectionView = {
        let layout: IROShapesCollectionViewFlowLayout = IROShapesCollectionViewFlowLayout()
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
        
        self.buyCoinsButton.topAnchor.constraint(equalTo: self.shapesCollectionView.bottomAnchor, constant: 60.0).isActive = true
        self.buyCoinsButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.buyCoinsButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.buyCoinsButton.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scaleCells()
    }
    
    let minScale: CGFloat = 0.5
    let maxScale: CGFloat = 1.0
    
    // Makes cells bigger when closer to the center
    func scaleCells() {
        
        var closestToCenterIndex: Int = 0
        var closestDistance: CGFloat = 1000000 // High number to start
        
        for cell in self.shapesCollectionView.visibleCells {
            let distanceFromCenter: CGFloat = abs(self.shapesCollectionView.bounds.width / 2.0 - (cell.frame.midX - self.shapesCollectionView.contentOffset.x))
            
            if distanceFromCenter < closestDistance {
                closestDistance = distanceFromCenter
                closestToCenterIndex = self.shapesCollectionView.indexPath(for: cell)!.item
            }
            
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
        
        self.closestToCenterIndex = closestToCenterIndex
    }

    // MARK: - Actions
    func tappedBuyCoinsButton(sender: UIButton) {
        self.delegate?.tipView(view: self, didSelectBuyCoinsButton: sender)
    }
    
    func tappedCloseButton(sender: UIButton) {
        self.delegate?.tipView(view: self, didSelectCloseButton: sender)
    }
    
}

extension IROTipView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shapes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: IROShapeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.shapeReuseId, for: indexPath) as! IROShapeCollectionViewCell
        let shape: IROShape = self.shapes[indexPath.item]
        if let name: String = shape.name {
            cell.shapeImageView.image = UIImage(named: name)
        }
        
        return cell
    }
    
}

extension IROTipView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let shape: IROShape = self.shapes[indexPath.item]
        
        // Don't include the start and end buffer shapes
        if shape.name != nil {
            self.delegate?.tipView(view: self, didSelectShape: shape)
        }
    }
    
}

extension IROTipView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width / 3.0 // Hack
        return CGSize(width: width, height: 150.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}

class IROShapesCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x
        let targetRect = CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: self.collectionView!.bounds.size)
        
        for layoutAttributes in super.layoutAttributesForElements(in: targetRect)! {
            let itemOffset = layoutAttributes.frame.origin.x
            if (abs(itemOffset - horizontalOffset) < abs(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
    
}
