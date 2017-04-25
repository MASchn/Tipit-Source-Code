//
//  UIImage+Download.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 4/25/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func download(urlString: String, completion: @escaping (UIImage?) -> Void) {
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
