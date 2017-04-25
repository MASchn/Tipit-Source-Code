//
//  IROAPIClient.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 4/6/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import Foundation
import Alamofire

class IROAPIClient: NSObject {
    
    static let baseURL: String = "https://powerful-reef-30384.herokuapp.com"
    
    class func getPersonalStory(completionHandler: @escaping ([IROMediaItem]?) -> Void) {
//        print("Requesting story")
        guard let user: IROUser = IROUser.currentUser else {
            print("No current user")
            return
        }
        
        let headers: HTTPHeaders = [
            "x-auth" : user.token,
            "Content-Type" : "application/json"
        ]
        Alamofire.request(self.baseURL + "/users/me/media_items", headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let JSONDictionary):
                if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                    var mediaItems: [IROMediaItem] = []
                    if let mediaItemsJSON: [[String : Any]] = JSON["mediaItems"] as? [[String : Any]] {
                        print("Story with \(mediaItemsJSON.count) posts successfully requested")
                        for mediaItemJSON: [String : Any] in mediaItemsJSON {
                            if let mediaItem: IROMediaItem = IROMediaItem(JSON: mediaItemJSON) {
                                mediaItems.append(mediaItem)
                            }
                        }
                        completionHandler(mediaItems)
                    }
                }
            case .failure(let error):
                print(error)
                completionHandler(nil)
            }
        }
    }
    
    class func registerNewUser(username: String, email: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        let parameters: Parameters = [
            "username" : username,
            "email" : email,
            "password" : password
        ]
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        Alamofire.request(
            self.baseURL + "/users",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: header
            ).responseJSON { (response) in
                switch response.result {
                case .success(let JSONDictionary):
                    if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                        self.parseUserJSON(JSON: JSON, completionHandler: completionHandler)
                    }
                case .failure(let error):
                    print("Sign up request failed with error \(error)")
                    completionHandler(false)
                }
        }
    }
    
    class func logInUser(email: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        let parameters: Parameters = [
            "email" : email,
            "password" : password
        ]
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        Alamofire.request(
            self.baseURL + "/users/login",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseJSON { (response) in
            switch response.result {
            case .success(let JSONDictionary):
                if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                    self.parseUserJSON(JSON: JSON, completionHandler: completionHandler)
                }
            case .failure(let error):
                print("Log in request failed with error \(error)")
                completionHandler(false)
            }
        }
    }
    
    class func updateUser(username: String?, fullname: String?, website: String?, bio: String?, completionHandler: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            "x-auth" : IROUser.currentUser!.token,
            "Content-Type" : "application/json"
        ]
        let parameters: Parameters = [
            "username" : username ?? "",
            "first_name" : fullname ?? "",
            "website" : website ?? "",
            "bio" : bio ?? ""
        ]
        Alamofire.request(self.baseURL + "/users", method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let JSONDictionary):
                if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                    self.parseUserJSON(JSON: JSON, completionHandler: { (success: Bool) in
                        completionHandler(success)
                    })
                }
            case .failure(let error):
                completionHandler(false)
                print("Update user request failed with error \(error)")
            }
        }
    }
    
    enum IROUserImageType: String  {
        case profile = "profile_image"
        case background = "background_image"
    }
    
    class func updateUserImage(data: Data, type: IROUserImageType, completionHandler: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            "x-auth" : IROUser.currentUser!.token,
            "content" : "image"
        ]
        
        Alamofire.upload(data, to: self.baseURL + "/users?image_type=" + type.rawValue, method: .patch, headers: headers).responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let JSONDictionary):
                if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                    self.parseUserJSON(JSON: JSON, completionHandler: { (success: Bool) in
                        completionHandler(success)
                    })
                }
            case .failure(let error):
                completionHandler(false)
                print("Update user request failed with error \(error)")
            }
        }
    }
    
    // Helper method
    class func parseUserJSON(JSON: [String : Any], completionHandler: (Bool) -> Void) {
        let username: String? = JSON["username"] as? String // Username will exist for sign up but not log in
        let fullName: String? = JSON["first_name"] as? String
        let website: String? = JSON["website"] as? String
        let bio: String? = JSON["bio"] as? String
        let profileImageURL: String? = JSON["profile_image"] as? String
        let backgroundImageURL: String? = JSON["background_image"] as? String
        
        if let _: IROUser = IROUser.currentUser {
            IROUser.currentUser?.username = username
            IROUser.currentUser?.fullName = fullName
            IROUser.currentUser?.website = website
            IROUser.currentUser?.bio = bio
            if let profileImageURL: String = profileImageURL {
                IROUser.currentUser?.profileImageURL = baseURLString + "/" + profileImageURL
            }
            if let backgroundImageURL: String = backgroundImageURL {
                IROUser.currentUser?.backgroundImageURL = baseURLString + "/" + backgroundImageURL
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
                bio: bio
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
    
    enum IROContentType: String {
        case image = "image"
        case video = "video"
    }
    
    class func post(user: IROUser, content: Data, type: IROContentType, private: Bool, completionHandler: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            "x-auth" : user.token
        ]
        Alamofire.upload(content, to: self.baseURL + "/media_items?file_type=\(type.rawValue)", method: .post, headers: headers).responseJSON { (response) in
            print(response)
            completionHandler(true)
        }
    }
    
    class func forgotPassword(email: String, completionHandler: @escaping (Bool) -> Void) {
        let parameters: Parameters = [
            "email" : email,
            ]
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        Alamofire.request(
            self.baseURL + "/forgot_password",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseJSON { (response) in
            switch response.result {
            case .success(let JSONDictionary):
                completionHandler(true)
            case .failure(let error):
                completionHandler(false)
            }
        }
    }
    
}
