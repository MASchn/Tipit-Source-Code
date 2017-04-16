//
//  IROPost.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 2/2/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import Foundation
import UIKit

struct IROPost {
    var user: IROUser
    var contentURL: String?
    var contentImage: UIImage?
    var index: Int? // The index of a post in a story
    var type: IROContentType = .photo
    var isPrivate: Bool
    
    init(user: IROUser, contentURL: String?, contentImage: UIImage?, index: Int?, isPrivate: Bool) {
        self.user = user
        self.contentURL = contentURL
        self.contentImage = contentImage
        self.index = index
        self.isPrivate = isPrivate
    }
}
