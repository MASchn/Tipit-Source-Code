//
//  IROParser.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 6/26/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit
import Alamofire

class IROParser: NSObject {
    
    class func parse(response: DataResponse<Any>) -> [IROSearchUser]? {
        switch response.result {
        case .success(let JSONDictionary):
            if let JSONArray: [[String : Any]] = JSONDictionary as? [[String : Any]] {
                var searchItems: [IROSearchUser] = [IROSearchUser]()
                for JSON: [String : Any] in JSONArray {
                    if let searchItem: IROSearchUser = IROSearchUser(JSON: JSON) {
                        searchItems.append(searchItem)
                    }
                }
                return searchItems
            } else {
                return nil
            }
        case .failure(let error):
            return nil
        }
        
    }
    

}
