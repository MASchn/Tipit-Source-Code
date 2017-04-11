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
    let username: String?
    let email: String?
    let token: String
    let profileImage: UIImage?
    static var currentUser: IROUser?
    
    func save() {
        UserDefaults.standard.set(self.username, forKey: "username")
        UserDefaults.standard.set(self.email, forKey: "email")
        UserDefaults.standard.set(self.token, forKey: "token")
        UserDefaults.standard.set(self.profileImage, forKey: "image")
    }
    
    static func logOut() {
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "token")
        self.currentUser = nil
    }
    
    static func fetchUserFromDefaults() -> IROUser? {
        if let token: String = UserDefaults.standard.object(forKey: "token") as? String {
            let username: String? = UserDefaults.standard.object(forKey: "username") as? String
            let email: String? = UserDefaults.standard.object(forKey: "email") as? String
            let image: UIImage? = UserDefaults.standard.object(forKey: "image") as? UIImage
            return IROUser(
                username: username,
                email: email,
                token: token,
                profileImage: image
            )
        }
        return nil
    }
}
