//
//  IROStory.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 2/2/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import Foundation
import UIKit

struct IROStory {
    let posts: [IROPost]
    
    static func mockStory() -> IROStory {
        let user1: IROUser = IROUser(username: "Hanna Julie Marie", email: "user1@gmail.com", token: "token", profileImage: #imageLiteral(resourceName: "user1"))
        let user2: IROUser = IROUser(username: "Silvia Marie Ann", email: "user2@gmail.com", token: "token", profileImage: #imageLiteral(resourceName: "user2"))
        
        let post1: IROPost = IROPost(user: user1, contentImage: UIImage(named: "feed_image_1")!, index: 0)
        let post2: IROPost = IROPost(user: user2, contentImage: UIImage(named: "feed_image_2")!, index: 1)
        let post3: IROPost = IROPost(user: user1, contentImage: UIImage(named: "feed_image_1")!, index: 2)
        let post4: IROPost = IROPost(user: user2, contentImage: UIImage(named: "feed_image_2")!, index: 3)
        let post5: IROPost = IROPost(user: user1, contentImage: UIImage(named: "feed_image_1")!, index: 4)
        let post6: IROPost = IROPost(user: user2, contentImage: UIImage(named: "feed_image_2")!, index: 5)
        let post7: IROPost = IROPost(user: user1, contentImage: UIImage(named: "feed_image_1")!, index: 6)
        let post8: IROPost = IROPost(user: user2, contentImage: UIImage(named: "feed_image_2")!, index: 7)
        return IROStory(posts: [post1, post2, post3, post4, post5, post6, post7, post8])
    }
    
    static func story(with user: IROUser, mediaItems: [IROMediaItem], completion: @escaping (IROStory?) -> Void) {
        var posts: [IROPost] = []
        let firstGroup = DispatchGroup()
        for index: Int in 0..<mediaItems.count {
            let item: IROMediaItem = mediaItems[index]
            firstGroup.enter()
            self.downloadImage(urlString: item.url, completion: { (image: UIImage?) in
                if let image: UIImage = image {
                    let post: IROPost = IROPost(
                        user: user,
                        contentImage: image,
                        index: index
                    )
                    posts.append(post)
                }
                firstGroup.leave()
            })
        }
        // Called when all posts have finished loading
        firstGroup.notify(queue: DispatchQueue.main) { 
            let story: IROStory = IROStory(posts: posts)
            completion(story)
        }
    }
    
    static func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let url: URL = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if let data: Data = data {
                    let image: UIImage? = UIImage(data: data)
                    completion(image)
                } else {
                    completion(nil)
                }
                }.resume()
        }
    }
    
}
