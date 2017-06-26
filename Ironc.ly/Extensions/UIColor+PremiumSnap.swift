//
//  UIColor+PremiumSnap.swift
//  Ironc.ly
//

import UIKit

extension UIColor {
    
    class var iroGreen: UIColor {
        return UIColor(red: 170/255.0, green: 229/255.0, blue: 0.0, alpha: 1.0)
    }
    
    class var iroGray: UIColor {
        return UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1.0)
    }
    
    class var iroDarkGray: UIColor {
        return UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0)
    }
    
    class var sampleColor1: UIColor {
        return UIColor(hex: "#04E762")
    }
    
    class var sampleColor2: UIColor {
        return UIColor(hex: "#F5B700")
    }
    
    class var sampleColor3: UIColor {
        return UIColor(hex: "#00A1E4")
    }
    
    class var sampleColor4: UIColor {
        return UIColor(hex: "#DC0073")
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            self.init(white: 0.0, alpha: 1.0)
        } else {
            let rString = (cString as NSString).substring(to: 2)
            let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
            let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
            
            var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
            Scanner(string: rString).scanHexInt32(&r)
            Scanner(string: gString).scanHexInt32(&g)
            Scanner(string: bString).scanHexInt32(&b)
            
            self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
        }
    }
    
}

