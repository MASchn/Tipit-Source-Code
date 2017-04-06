//
//  IROMediaItem.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 4/6/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import Foundation

let baseURLString: String = "https://s3-us-west-2.amazonaws.com/moneyshot-cosmo"

struct IROMediaItem {
    enum IROMediaItemType {
        case photo
        case video
    }
    
    init?(JSON: [String : Any]) {
        guard let url: String = JSON["url"] as? String else {
            return nil
        }
        self.url = baseURLString + "/" + url
    }
    
    let url: String
    let type: IROMediaItemType = .photo
}
