//
//  TIPFeedItem.swift
//  Ironc.ly
//

import UIKit

class TIPFeedItem: NSObject {
    
    var userId: String
    var storyImage: String
    var backgroundImageURL: String?
    var profileImageURL: String?
    var username: String?
    var timeRemaining: String?
    var isPrivate: Bool
    var profileImage: UIImage?
    var isSubscribed: Bool?
    
    init?(JSON: [String : Any]) {
        guard let userId: String = JSON["user_id"] as? String else { return nil }
        guard let storyImage: String = JSON["story_image"] as? String else { return nil }
        
        self.userId = userId
        self.storyImage = storyImage
        self.backgroundImageURL = JSON["background_image"] as? String
        self.profileImageURL = JSON["profile_image"] as? String
        self.username = JSON["username"] as? String
        self.timeRemaining = JSON["time_remaining"] as? String
        self.isPrivate = JSON["private"] as? Bool ?? false
        self.isSubscribed = JSON["isSubscribed"] as? Bool ?? false
    }
    
}
