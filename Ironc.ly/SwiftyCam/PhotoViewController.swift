/*Copyright (c) 2016, Andrew Walz.
 
 Redistribution and use in source and binary forms, with or without modification,are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyrighvarotice, this list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
 BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

import UIKit
import Alamofire
import CoreGraphics
import CoreImage

class PhotoViewController: TIPPreviewViewController {
    
    var backgroundImageViewBottom: NSLayoutConstraint?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var backgroundImage: UIImage
    var imageWithFilter: UIImage
    let filterReUseID = "filter"
    let filters = [CIFilter(name:""), CIFilter(name: "CIPhotoEffectNoir"), CIFilter(name:"CIPixellate"), CIFilter(name: "CISepiaTone"), CIFilter(name:"CIPhotoEffectFade"), CIFilter(name:"CIPhotoEffectInstant")]
    var finishedImages = [UIImage?]()
    let context = CIContext(options: nil)
    var extent: CGRect?
    var scaleFactor: CGFloat?
    
    init(image: UIImage) {
        self.backgroundImage = image
        self.imageWithFilter = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray
        
        self.imageWithFilter = self.backgroundImage
        
        self.view.addSubview(self.backgroundImageView)
        self.backgroundImageView.image = backgroundImage
        
        self.backgroundImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideCollectionView))
        self.backgroundImageView.addGestureRecognizer(tap)
        
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 44.0, height: 44.0))
        let image: UIImage = #imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysTemplate)
        cancelButton.setImage(image, for: UIControlState())
        cancelButton.tintColor = UIColor.white
        cancelButton.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        
        self.view.addSubview(self.filterCollectionView)
        self.view.addSubview(self.pullUpFiltersButton)
        
        self.view.bringSubview(toFront: self.publicButton)
        self.view.bringSubview(toFront: self.privateButton)
        self.view.bringSubview(toFront: self.sendToFriendButton)
        
        self.sendToFriendButton.addTarget(self, action: #selector(self.share), for: .touchUpInside)
        
        self.publicButton.addTarget(self, action: #selector(self.tappedPublicButton), for: .touchUpInside)
        self.privateButton.addTarget(self, action: #selector(self.tappedPrivateButton), for: .touchUpInside)
        
            setUpFilterConstraints()
        
        self.scaleFactor = UIScreen.main.scale
        self.extent = UIScreen.main.bounds.applying(CGAffineTransform(scaleX: self.scaleFactor!, y: self.scaleFactor!))
        let imgOrientation = self.backgroundImage.imageOrientation
        let imgScale = self.backgroundImage.scale
        
        let ciImage = CIImage(image: self.backgroundImage)
        
        var i = 0
        
        for filter in self.filters {
            
            self.finishedImages.append(self.backgroundImage)
            
            if self.filters[0] == filter {
                //self.finishedImages.append(self.backgroundImage)
                
            } else {
            
            //DispatchQueue.global().async {
             
                filter?.setDefaults()
                filter?.setValue(ciImage, forKey: kCIInputImageKey)
                
                
                let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
                let filteredImageRef = self.context.createCGImage(filteredImageData, from: filteredImageData.extent)
                let finishedImage = UIImage(cgImage:filteredImageRef!, scale:imgScale, orientation:imgOrientation)
                
                self.finishedImages[i] = finishedImage
                
                
            //}
                
            }
            i = i + 1
        }
        
        
    }
    
    //MARK: -Lazy Initializers
    lazy var filterCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.iroGray
        collectionView.alwaysBounceVertical = false
        collectionView.bounces = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(TIPFilterCollectionViewCell.self, forCellWithReuseIdentifier: self.filterReUseID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        return collectionView
    }()

    lazy var backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var pullUpFiltersButton: UIButton = {
        let button: UIButton = UIButton()
        button.addTarget(self, action: #selector(self.pullUpCollectionView), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "triangle_button-1"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setUpFilterConstraints(){
        
        self.filterCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.filterCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.filterCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.filterCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
        
        self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        backgroundImageViewBottom = self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        backgroundImageViewBottom?.isActive = true
        
        self.pullUpFiltersButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.pullUpFiltersButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15).isActive = true
        self.pullUpFiltersButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.07).isActive = true
        self.pullUpFiltersButton.widthAnchor.constraint(equalTo: self.pullUpFiltersButton.heightAnchor).isActive = true
        
    }
    
    func pullUpCollectionView() {
        self.filterCollectionView.isHidden = false
        self.privateButton.isHidden = true
        self.publicButton.isHidden = true
        self.sendToFriendButton.isHidden = true
        self.pullUpFiltersButton.isHidden = true
        backgroundImageViewBottom?.constant = -self.filterCollectionView.bounds.height
    }
    
    func hideCollectionView() {
        self.filterCollectionView.isHidden = true
        self.privateButton.isHidden = false
        self.publicButton.isHidden = false
        self.sendToFriendButton.isHidden = false
        self.pullUpFiltersButton.isHidden = false
        backgroundImageViewBottom?.constant = 0
    }
    
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func share() {
        let shareText: String = "Sent with PremiumSnap"
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [self.backgroundImage, shareText], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    func tappedPublicButton(sender: UIButton) {
        self.postContent(isPrivate: false)
    }
    
    func tappedPrivateButton(sender: UIButton) {
        self.postContent(isPrivate: true)
    }
    
    func postContent(isPrivate: Bool) {
        guard let user: TIPUser = TIPUser.currentUser else { return }

        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
            if let data: Data = UIImageJPEGRepresentation(self.imageWithFilter, 0.0) {
                TIPAPIClient.postContent(
                    user: user,
                    content: data,
                    type: .image,
                    isPrivate: isPrivate,
                    completionHandler: { (success: Bool) in
                        print("Successfully uploaded content")
                })
            }
        })
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TIPFilterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.filterReUseID, for: indexPath) as! TIPFilterCollectionViewCell
        //let filterItem = self.filters[indexPath.item]
        
//        if indexPath.item == 0 {
//            cell.filterImageView.image = self.backgroundImage
//            //cell.finishedImage = self.backgroundImage
//            return cell
//        }
        
        cell.filterImageView.image = self.finishedImages[indexPath.item]
       //cell.filterImageView.image = self.backgroundImage
        
        //background queue
        
//            let data = try? Data(contentsOf: backgroundImage.downloadURL)
            //cell.filterImageView.image = self.backgroundImage
        
                
//                currentPhoto.actualImage = UIImage(data: data!)
//                if cell.finishedImage == nil {
//                    DispatchQueue.global().async {
//                    self.scaleFactor = UIScreen.main.scale
//                    self.extent = UIScreen.main.bounds.applying(CGAffineTransform(scaleX: self.scaleFactor!, y: self.scaleFactor!))
//                    let imgOrientation = self.backgroundImage.imageOrientation
//                    let imgScale = self.backgroundImage.scale
//                    
//                    let ciImage = CIImage(image: self.backgroundImage)
//                    
//                    
//                    filterItem?.setDefaults()
//                    filterItem?.setValue(ciImage, forKey: kCIInputImageKey)
//                    //                filterItem?.setValue(25, forKey: kCIInputWidthKey)
//                    
//                    
//                    
//                    let filteredImageData = filterItem!.value(forKey: kCIOutputImageKey) as! CIImage
//                    let filteredImageRef = self.context.createCGImage(filteredImageData, from: filteredImageData.extent)
//                    let finishedImage = UIImage(cgImage:filteredImageRef!, scale:imgScale, orientation:imgOrientation)
//                    
//                    DispatchQueue.main.async {
//                    cell.filterImageView.image = finishedImage
//                    cell.finishedImage = finishedImage
//                        }
//                    }
//                } else {
//                    cell.filterImageView.image = cell.finishedImage
//                }

            

        
        
        
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let cell = collectionView.cellForItem(at: indexPath) as! TIPFilterCollectionViewCell
        
        self.backgroundImageView.image = self.finishedImages[indexPath.item]
        self.imageWithFilter = self.finishedImages[indexPath.item]!
        
        
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.height - 10, height: collectionView.bounds.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

