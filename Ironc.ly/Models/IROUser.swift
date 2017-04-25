//
//  IROUser.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 2/2/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import Foundation
import UIKit

struct IROUser {
    var username: String?
    var email: String?
    let token: String
    var fullName: String?
    var profileImage: UIImage?
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
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(self.username, forKey: "username")
        defaults.set(self.email, forKey: "email")
        defaults.set(self.token, forKey: "token")
        defaults.set(self.fullName, forKey: "full_name")
        defaults.set(self.profileImage, forKey: "image")
        defaults.set(self.backgroundImage, forKey: "background")
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
            let image: UIImage? = defaults.object(forKey: "image") as? UIImage
            let background: UIImage? = defaults.object(forKey: "background") as? UIImage
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
