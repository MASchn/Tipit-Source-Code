//
//  UIImage+URL.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 4/25/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func download(urlString: String?, placeHolder: UIImage? = nil, completion: @escaping (UIImage?) -> Void) {
        guard let urlString: String = urlString else {
            completion(placeHolder)
            return
        }
        
        guard let url: URL = URL(string: urlString) else {
            completion(placeHolder)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data: Data = data else {
                completion(placeHolder)
                return
            }
            
            let image: UIImage? = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }

        }.resume()

    }
    
}
