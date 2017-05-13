//
//  IROSearchUser.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 5/10/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROSearchUser: NSObject {
    
    var userId: String
    var mediaItemURL: String?
    var username: String?
    var name: String?
    var profileImageURL: String?
    
    // MARK: - Initialization
    init?(JSON: [String : Any]) {
        guard let userId: String = JSON["id"] as? String else { return nil }
        guard let profileImage: String = JSON["profile_image"] as? String else { return nil }
        guard Array(profileImage.characters).first == "h" else { return nil }
        
        self.userId = userId
        
        if let mediaItem: String = (JSON["media_item"] as? [String : Any])?["url"] as? String {
            self.mediaItemURL = mediaItem
        }
        self.username = JSON["username"] as? String
        self.name = JSON["name"] as? String
        self.profileImageURL = profileImage
    }

}
