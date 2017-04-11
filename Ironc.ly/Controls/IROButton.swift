//
//  IROButton.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 4/11/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

enum IROButtonStyle {
    case green
    case white
    case clear
}

class IROButton: UIButton {
    
    // MARK: - View Lifecycle
    convenience init(style: IROButtonStyle) {
        self.init(frame: .zero)
        
        switch style {
        case .green:
            self.setTitleColor(.black, for: .normal)
            self.setTitleColor(.white, for: .highlighted)
            self.backgroundColor = IROConstants.green
        case .white:
            self.setTitleColor(.black, for: .normal)
            self.setTitleColor(.lightGray, for: .highlighted)
            self.backgroundColor = .white
        case .clear:
            self.setTitleColor(.white, for: .normal)
            self.setTitleColor(.lightGray, for: .highlighted)
            self.layer.borderColor = UIColor.white.cgColor
            self.layer.borderWidth = 1.0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.font = .systemFont(ofSize: 18.0, weight: UIFontWeightMedium)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
