//
//  UIImage+URL.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 4/25/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func download(urlString: String, placeHolder: UIImage? = nil, completion: @escaping (UIImage?) -> Void) {
        if let url: URL = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                if let data: Data = data {
                    let image: UIImage? = UIImage(data: data)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(placeHolder)
                    }
                }
            }.resume()
        } else {
            print("Invalid URL: \(urlString)")
            completion(placeHolder)
        }
    }
    
}
