//
//  TIPSearchUser.swift
//  Ironc.ly
//

import UIKit

class TIPSearchUser: NSObject {
    
    var userId: String
    var mediaItemURL: String?
    var username: String?
    var name: String?
    var profileImageURL: String?
    var backgroundImageURL: String?
    var following: Bool
    
    // MARK: - Initialization
    init?(JSON: [String : Any]) {
        guard let userId: String = JSON["id"] as? String else { return nil }
        guard let username: String = JSON["username"] as? String else { return nil }
        guard username.characters.count > 0 else { return nil }
        
        if let profileImage: String = JSON["profile_image"] as? String {
            self.profileImageURL = profileImage
        }
        
        if let backgroundImage: String = JSON["background_image"] as? String {
            self.backgroundImageURL = backgroundImage
        }
        
        self.userId = userId
        
        if let mediaItem: String = (JSON["media_item"] as? [String : Any])?["url"] as? String {
            self.mediaItemURL = mediaItem
        }
        
        self.username = username
        self.name = JSON["name"] as? String
        self.following = JSON["following"] as? Bool ?? false
    }

}
