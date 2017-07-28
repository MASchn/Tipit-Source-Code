//
//  UIImage+URL.swift
//  Ironc.ly
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

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

extension UIImageView {
    
    func loadImageUsingCacheFromUrlString(urlString: String, placeHolder: UIImage?, completion: @escaping () -> Void) {
        
        let NSUrlString = urlString as NSString
        
        if let cachedImage = imageCache.object(forKey: NSUrlString)  {
            self.image = cachedImage
            completion()
            return
        }
        
        UIImage.download(urlString: urlString, placeHolder: placeHolder) { (image) in
            
            self.image = image
            
            guard let url: URL = URL(string: urlString) else {
                completion()
                return
            }
            
            imageCache.setObject(image!, forKey: NSUrlString)
            completion()
        }
        
        
    }
}
