//
//  TIPParser.swift
//  Ironc.ly
//

import UIKit
import Alamofire

class TIPParser: NSObject {
    
    class func parse(response: DataResponse<Any>) -> [TIPSearchUser]? {
        switch response.result {
        case .success(let JSONDictionary):
            if let JSONArray: [[String : Any]] = JSONDictionary as? [[String : Any]] {
                var searchItems: [TIPSearchUser] = [TIPSearchUser]()
                for JSON: [String : Any] in JSONArray {
                    if let searchItem: TIPSearchUser = TIPSearchUser(JSON: JSON) {
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
