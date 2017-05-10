//
//  IROSearchItem.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 5/10/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROSearchItem: NSObject {
    
    var mediaItemURL: String?
    var username: String?
    var name: String?
    var profileImageURL: String?
    
    // MARK: - Initialization
    init?(JSON: [String : Any]) {
        if let mediaItem: String = (JSON["media_item"] as? [String : Any])?["url"] as? String {
            self.mediaItemURL = amazons3 + "/" + mediaItem
        }
        self.username = JSON["username"] as? String
        self.name = JSON["name"] as? String
        if let profileImage: String = JSON["profile_image"] as? String {
            self.profileImageURL = amazons3 + "/" + profileImage
        }
    }

}
