//
//  CALayer+TextField.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 3/31/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

extension CALayer {
    
    class func createTextFieldBorder(textField: UITextField) -> CALayer {
        let width: CGFloat = 1.0
        let border: CALayer = CALayer()
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: textField.frame.size.width, height: textField.frame.size.height)
        border.borderColor = UIColor.white.cgColor
        border.borderWidth = width
        return border
    }
    
}
