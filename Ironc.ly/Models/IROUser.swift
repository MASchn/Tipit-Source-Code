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
    var profileImageURL: String?
    var profileImage: UIImage?
    var backgroundImageURL: String?
    var backgroundImage: UIImage?
    var website: String?
    var bio: String?
    var coins: Int
    
    static var currentUser: IROUser?
    let defaults = UserDefaults.standard
    
    // MARK: - Initialization
    class func parseUserJSON(JSON: [String : Any], completionHandler: (Bool) -> Void) {
        let username: String? = JSON["username"] as? String // Username will exist for sign up but not log in
        let fullName: String? = JSON["first_name"] as? String
        let website: String? = JSON["website"] as? String
        let bio: String? = JSON["bio"] as? String
        let profileImageURL: String? = JSON["profile_image"] as? String
        let backgroundImageURL: String? = JSON["background_image"] as? String
        let coins: Int = JSON["coins"] as? Int ?? 0
        
        if let _: IROUser = IROUser.currentUser {
            IROUser.currentUser?.username = username
            IROUser.currentUser?.fullName = fullName
            IROUser.currentUser?.website = website
            IROUser.currentUser?.bio = bio
            IROUser.currentUser?.coins = coins
            if let profileImageURL: String = profileImageURL {
                IROUser.currentUser?.profileImageURL = profileImageURL
            }
            if let backgroundImageURL: String = backgroundImageURL {
                IROUser.currentUser?.backgroundImageURL = backgroundImageURL
            }
            IROUser.currentUser?.save()
            completionHandler(true)
        }
        else if
            let email: String = JSON["email"] as? String,
            let token: String = JSON["token"] as? String
        {
            let user: IROUser = IROUser(
                username: username,
                email: email,
                token: token,
                fullName: fullName,
                profileImageURL: profileImageURL,
                backgroundImageURL: backgroundImageURL,
                website: website,
                bio: bio,
                coins: coins
            )
            user.save()
            IROUser.currentUser = user
            completionHandler(true)
        }
        else
        {
            print("Error parsing user response")
            completionHandler(false)
        }
    }
    
    init(token: String) {
        self.token = token
        self.email = nil
        self.coins = 0
    }
    
    init(username: String?, email: String?, token: String, profileImage: UIImage?) {
        self.username = username
        self.email = email
        self.token = token
        self.profileImage = profileImage
        self.coins = 0
    }
    
    init(username: String?, email: String?, token: String, fullName: String?, profileImage: UIImage?, backgroundImage: UIImage?, website: String?, bio: String?, coins: Int) {
        self.username = username
        self.email = email
        self.token = token
        self.fullName = fullName
        self.profileImage = profileImage
        self.backgroundImage = backgroundImage
        self.website = website
        self.bio = bio
        self.coins = coins
    }
    
    init(username: String?, email: String?, token: String, fullName: String?, profileImageURL: String?, backgroundImageURL: String?, website: String?, bio: String?, coins: Int) {
        self.username = username
        self.email = email
        self.token = token
        self.fullName = fullName
        self.profileImageURL = profileImageURL
        self.backgroundImageURL = backgroundImageURL
        self.website = website
        self.bio = bio
        self.coins = coins
    }
    
    func save() {
        self.defaults.set(self.username, forKey: "username")
        self.defaults.set(self.email, forKey: "email")
        self.defaults.set(self.token, forKey: "token")
        self.defaults.set(self.fullName, forKey: "full_name")
        if let profileImage: UIImage = self.profileImage {
            if let profileData: Data = UIImageJPEGRepresentation(profileImage, 0.5) {
                self.defaults.set(profileData, forKey: "image")
            }
        }
        if let backgroundImage: UIImage = self.backgroundImage {
            if let backgroundData: Data = UIImageJPEGRepresentation(backgroundImage, 0.5) {
                defaults.set(backgroundData, forKey: "background")
            }
        }
        self.defaults.set(self.website, forKey: "website")
        self.defaults.set(self.bio, forKey: "bio")
        self.defaults.set(self.coins, forKey: "coins")
        self.defaults.synchronize()
    }
    
    func updateCoins(newAmount: Int) {
        self.defaults.set(newAmount, forKey: "coins")
        self.defaults.synchronize()
    }
    
    func logOut() {
        self.defaults.removeObject(forKey: "email")
        self.defaults.removeObject(forKey: "token")
        self.defaults.removeObject(forKey: "image")
        self.defaults.removeObject(forKey: "background")
        IROUser.currentUser = nil
    }
    
    static func fetchUserFromDefaults() -> IROUser? {
        let defaults: UserDefaults = UserDefaults.standard
        if let token: String = defaults.object(forKey: "token") as? String {
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
            let coins: Int = defaults.integer(forKey: "coins")
            return IROUser(
                username: username,
                email: email,
                token: token,
                fullName: fullName,
                profileImage: image,
                backgroundImage: background,
                website: website,
                bio: bio,
                coins: coins
            )
        }
        return nil
    }
    
}
