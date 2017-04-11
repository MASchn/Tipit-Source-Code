//
//  IROTextField.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 4/11/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROTextField: UITextField {
    
    let fontName: String = "HelveticaNeue-MediumItalic"
    
    // MARK: - View Lifecycle
    convenience init(placeholder: String) {
        self.init(frame: .zero)
        
        let placeholderString: NSAttributedString = NSAttributedString(
            string: placeholder,
            attributes:
            [
                NSFontAttributeName : UIFont(name: self.fontName, size: 18.0)!,
                NSForegroundColorAttributeName : UIColor.white
            ]
        )
        self.attributedPlaceholder = placeholderString
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textColor = UIColor.white
        self.font = UIFont(name: self.fontName, size: 18.0)
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let border: CALayer = self.createBorder()
        self.layer.addSublayer(border)
    }
    
    func createBorder() -> CALayer {
        let width: CGFloat = 1.0
        let border: CALayer = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderColor = UIColor.white.cgColor
        border.borderWidth = width
        return border
    }

}
