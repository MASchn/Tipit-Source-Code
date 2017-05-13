//
//  IROFeedItem.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 5/12/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROFeedItem: NSObject {
    
    var storyImage: String
    var backgroundImage: String?
    var profileImage: String?
    var username: String?
    var timeRemaining: String?
    var userId: String?
    
    init?(JSON: [String : Any]) {
        guard let storyImage: String = JSON["story_image"] as? String else { return nil }
        
        self.storyImage = storyImage
        self.backgroundImage = JSON["background_image"] as? String
        self.profileImage = JSON["profile_image"] as? String
        self.username = JSON["username"] as? String
        self.timeRemaining = JSON["time_remaining"] as? String
        self.userId = JSON["user_id"] as? String
    }
    
}
