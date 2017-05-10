//
//  IROSearch.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 5/10/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import Foundation
import Alamofire

class IROSearch: NSObject {
    
    class func getAllUsers(completionHandler: @escaping ([IROSearchItem]?) -> Void) {
        let headers: HTTPHeaders = [
            "x-auth" : IROUser.currentUser!.token,
            "Content-Type" : "application/json"
        ]
        Alamofire.request(baseURL + "/users", headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let JSONDictionary):
                if let JSONArray: [[String : Any]] = JSONDictionary as? [[String : Any]] {
                    var searchItems: [IROSearchItem] = [IROSearchItem]()
                    for JSON: [String : Any] in JSONArray {
                        if let searchItem: IROSearchItem = IROSearchItem(JSON: JSON) {
                            searchItems.append(searchItem)
                        }
                    }
                    completionHandler(searchItems)
                } else {
                    completionHandler(nil)
                }
            case .failure(let error):
                print(error)
                completionHandler(nil)
            }
        }
    }

}
