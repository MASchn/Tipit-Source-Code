//
//  IROUser.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 2/2/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import Foundation
import UIKit

class IROUser: NSObject {
    
    var username: String?
    var email: String?
    let token: String
    var fullName: String?
    var profileImageURL: String? {
        didSet {
            if let url: String = profileImageURL, url.isEmpty == false {
                UIImage.download(urlString: url, completion: { (image) in
                    self.profileImage = image
                    self.save()
                })
            }
        }
    }
    
    var profileImage: UIImage?
    var backgroundImageURL: String?
    var backgroundImage: UIImage?
    var website: String?
    var bio: String?
    
    static var currentUser: IROUser?
    static let defaults = UserDefaults.standard
    
    // MARK: - Initialization
    init(token: String) {
        self.token = token
        self.email = nil
    }
    
    init(username: String?, email: String?, token: String, profileImage: UIImage?) {
        self.username = username
        self.email = email
        self.token = token
        self.profileImage = profileImage
    }
    
    init(username: String?, email: String?, token: String, fullName: String?, profileImage: UIImage?, backgroundImage: UIImage?, website: String?, bio: String?) {
        self.username = username
        self.email = email
        self.token = token
        self.fullName = fullName
        self.profileImage = profileImage
        self.backgroundImage = backgroundImage
        self.website = website
        self.bio = bio
    }
    
    init(username: String?, email: String?, token: String, fullName: String?, profileImageURL: String?, backgroundImageURL: String?, website: String?, bio: String?) {
        self.username = username
        self.email = email
        self.token = token
        self.fullName = fullName
        self.profileImageURL = profileImageURL
        self.backgroundImageURL = backgroundImageURL
        self.website = website
        self.bio = bio
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(self.username, forKey: "username")
        defaults.set(self.email, forKey: "email")
        defaults.set(self.token, forKey: "token")
        defaults.set(self.fullName, forKey: "full_name")
        if let profileImage: UIImage = self.profileImage {
            if let profileData: Data = UIImageJPEGRepresentation(profileImage, 0.5) {
                defaults.set(profileData, forKey: "image")
            }
        }
        if let backgroundImage: UIImage = self.backgroundImage {
            if let backgroundData: Data = UIImageJPEGRepresentation(backgroundImage, 0.5) {
                defaults.set(backgroundData, forKey: "background")
            }
        }
        defaults.set(self.website, forKey: "website")
        defaults.set(self.bio, forKey: "bio")
        defaults.synchronize()
    }
    
    static func logOut() {
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "token")
        self.currentUser = nil
    }
    
    static func fetchUserFromDefaults() -> IROUser? {
        if let token: String = defaults.object(forKey: "token") as? String
        {
            let username: String? = defaults.object(forKey: "username") as? String
            let email: String? = defaults.object(forKey: "email") as? String
            let fullName: String? = defaults.object(forKey: "full_name") as? String
            var image: UIImage?
            if let profileData: Data = defaults.object(forKey: "image") as? Data {
                image = UIImage(data: profileData)
            }
            var background: UIImage?
            if let backgroundData: Data = defaults.object(forKey: "background") as? Data {
                background = UIImage(data: backgroundData)
            }
            let website: String? = defaults.object(forKey: "website") as? String
            let bio: String? = defaults.object(forKey: "bio") as? String
            return IROUser(
                username: username,
                email: email,
                token: token,
                fullName: fullName,
                profileImage: image,
                backgroundImage: background,
                website: website,
                bio: bio
            )
        }
        return nil
    }
}
