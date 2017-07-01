//
//  TIPPersonalProfileViewController.swift
//  Ironc.ly
//

import UIKit

class TIPPersonalProfileViewController: TIPProfileViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let user: TIPUser = TIPUser.currentUser else {
            return
        }
        
        self.nameLabel.text = user.fullName
        self.usernameLabel.text = user.username
        
        UIImage.download(urlString: user.profileImageURL, placeHolder: #imageLiteral(resourceName: "empty_profile")) { (image: UIImage?) in
            self.profileImageButton.setImage(image, for: .normal)
        }
        
        UIImage.download(urlString: user.backgroundImageURL, placeHolder: #imageLiteral(resourceName: "empty_background")) { (image: UIImage?) in
            self.backgroundImageView.image = image
        }
        
        TIPAPIClient.getPersonalStory { (story: TIPStory?) in
            if let story: TIPStory = story {
                self.story = story
                if let firstPost: TIPPost = story.posts.first {
                    self.storyPreviewButton.setImage(firstPost.contentImage, for: .normal)
                    self.storyPreviewButton.layer.borderWidth = 10.0
                }
            }
        }
    }

}
