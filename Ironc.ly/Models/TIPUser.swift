//
//  TIPUser.swift
//  Ironc.ly
//

import Foundation
import UIKit

class TIPUser: NSObject {
    
    var userId: String?
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
    var allAccess: Bool
    
    static var currentUser: TIPUser?
    let defaults = UserDefaults.standard
    
    // Log
    override var description: String {
        let header: String = "CURRENT USER"
        let divider: String = "===================="
        
        var fields: [String] = [header, divider]
        
        if let username: String = self.username {
            fields.append("USERNAME: \(username)")
        }
        if let email: String = self.email {
            fields.append("EMAIL: \(email)")
        }
        
        fields.append("TOKEN: \(token)")
        
        if let fullName: String = self.fullName {
            fields.append("NAME: \(fullName)")
        }
        
        if let profileImageURL: String = self.profileImageURL {
            fields.append("IMAGE: \(profileImageURL)")
        }
        
        if let backgroundImageURL: String = self.backgroundImageURL {
            fields.append("BACKGROUND: \(backgroundImageURL)")
        }
        
        fields.append("COINS: \(self.coins)")
        
        if self.allAccess == true {
            fields.append("UNLOCKED ALL CONTENT")
        }
        
        return fields.flatMap({$0}).joined(separator: "\n")
    }
    
    // MARK: - Initialization
    class func parseUserJSON(JSON: [String : Any], completionHandler: @escaping (Bool) -> Void) {
        
        print("USER JSON: \(JSON)")
        
        let userId: String? = JSON["id"] as? String
        let username: String? = JSON["username"] as? String // Username will exist for sign up but not log in
        let fullName: String? = JSON["first_name"] as? String
        let website: String? = JSON["website"] as? String
        let bio: String? = JSON["bio"] as? String
        let profileImageURL: String? = JSON["profile_image"] as? String
        let backgroundImageURL: String? = JSON["background_image"] as? String
        let coins: Int = JSON["coins"] as? Int ?? 0
        let allAccess: Bool = JSON["all_access"] as? Bool ?? false
        
        if let user: TIPUser = TIPUser.currentUser {
            user.username = username
            user.fullName = fullName
            user.website = website
            user.bio = bio
            user.coins = coins
            if let profileImageURL: String = profileImageURL {
                user.profileImageURL = profileImageURL
            }
            if let backgroundImageURL: String = backgroundImageURL {
                user.backgroundImageURL = backgroundImageURL
            }
            user.save()
            print("USER SAVED!\n\(user)")
            completionHandler(true)
        }
        else if
            let email: String = JSON["email"] as? String,
            let token: String = JSON["token"] as? String
        {
            let user: TIPUser = TIPUser(
                userId: userId,
                username: username,
                email: email,
                token: token,
                fullName: fullName,
                profileImageURL: profileImageURL,
                backgroundImageURL: backgroundImageURL,
                website: website,
                bio: bio,
                coins: coins,
                allAccess: allAccess
            )
            user.save()
            TIPUser.currentUser = user
            print("USER SAVED!/n\(user)")
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
        self.allAccess = false
    }
    
    init(username: String?, email: String?, token: String, profileImage: UIImage?) {
        self.username = username
        self.email = email
        self.token = token
        self.profileImage = profileImage
        self.coins = 0
        self.allAccess = false
    }
    
    init(userId: String?, username: String?, email: String?, token: String, fullName: String?, profileImage: UIImage?, backgroundImage: UIImage?, website: String?, bio: String?, coins: Int, allAccess: Bool) {
        self.userId = userId
        self.username = username
        self.email = email
        self.token = token
        self.fullName = fullName
        self.profileImage = profileImage
        self.backgroundImage = backgroundImage
        self.website = website
        self.bio = bio
        self.coins = coins
        self.allAccess = allAccess
    }
    
    init(userId: String?, username: String?, email: String?, token: String, fullName: String?, profileImageURL: String?, backgroundImageURL: String?, website: String?, bio: String?, coins: Int, allAccess: Bool) {
        self.userId = userId
        self.username = username
        self.email = email
        self.token = token
        self.fullName = fullName
        self.profileImageURL = profileImageURL
        self.backgroundImageURL = backgroundImageURL
        self.website = website
        self.bio = bio
        self.coins = coins
        self.allAccess = allAccess
    }
    
    func save() {
        self.defaults.set(self.userId, forKey: "user_id")
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
        self.defaults.set(self.allAccess, forKey: "all_access")
        self.defaults.synchronize()
    }
    
    func updateCoins(newValue: Int) {
        TIPUser.currentUser?.coins = newValue
        self.defaults.set(newValue, forKey: "coins")
        self.defaults.synchronize()
    }
    
    func updateAllAccess(newValue: Bool) {
        TIPUser.currentUser?.allAccess = newValue
        self.defaults.set(newValue, forKey: "all_access")
        self.defaults.synchronize()
    }
    
    func logOut() {
        self.defaults.removeObject(forKey: "email")
        self.defaults.removeObject(forKey: "token")
        self.defaults.removeObject(forKey: "image")
        self.defaults.removeObject(forKey: "background")
        TIPUser.currentUser = nil
    }
    
    static func fetchUserFromDefaults() -> TIPUser? {
        let defaults: UserDefaults = UserDefaults.standard
        if let token: String = defaults.object(forKey: "token") as? String {
            let userId: String? = defaults.object(forKey: "user_id") as? String
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
            let allAccess: Bool = defaults.bool(forKey: "all_access")
            return TIPUser(
                userId: userId,
                username: username,
                email: email,
                token: token,
                fullName: fullName,
                profileImage: image,
                backgroundImage: background,
                website: website,
                bio: bio,
                coins: coins,
                allAccess: allAccess
            )
        }
        return nil
    }
    
}
