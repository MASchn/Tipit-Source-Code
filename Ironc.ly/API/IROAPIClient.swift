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
    
    class func getPersonalStory(completionHandler: @escaping ([IROMediaItem]?) -> Void) {
        print("Requesting story")
        guard let user: IROUser = IROUser.currentUser else {
            print("No current user")
            return
        }
        
        let headers: HTTPHeaders = [
            "x-auth" : user.token,
            "content-type" : "application/json"
        ]
        Alamofire.request("https://powerful-reef-30384.herokuapp.com/users/me/media_items", headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let JSONDictionary):
                if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                    var mediaItems: [IROMediaItem] = []
                    if let mediaItemsJSON: [[String : Any]] = JSON["mediaItems"] as? [[String : Any]] {
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
            "https://powerful-reef-30384.herokuapp.com/users",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: header
            ).responseJSON { (response) in
                switch response.result {
                case .success(let JSONDictionary):
                    if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                        if
                            let username: String = JSON["username"] as? String,
                            let email: String = JSON["email"] as? String,
                            let token: String = JSON["token"] as? String
                        {
                            let user: IROUser = IROUser(
                                username: username,
                                email: email,
                                token: token,
                                profileImage: nil
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
                case .failure(let error):
                    print("Sign up request failed with error \(error)")
                    completionHandler(false)
                }
        }
    }

}
