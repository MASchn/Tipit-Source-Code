//
//  TIPTextField.swift
//  Ironc.ly
//

import UIKit

class TIPTextField: UITextField {
    
    let fontName: String = "HelveticaNeue-MediumItalic"
    let handWrittenFontName: String = "freehand"
    var fontSize: CGFloat?
    
    // MARK: - View Lifecycle
    convenience init(placeholder: String, fontSize: CGFloat) {
        self.init(frame: .zero)
        
        self.fontSize = fontSize
        
        self.font = UIFont(name: self.handWrittenFontName, size: self.fontSize!)
        
        let placeholderString: NSAttributedString = NSAttributedString(
            string: placeholder,
            attributes:
            [
                NSFontAttributeName : UIFont(name: self.handWrittenFontName, size: self.fontSize!)!,
                NSForegroundColorAttributeName : UIColor.gray
            ]
        )
        self.attributedPlaceholder = placeholderString
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textColor = UIColor.black
        //self.font = UIFont(name: self.handWrittenFontName, size: self.fontSize!)
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //let border: CALayer = self.createBorder()
        //self.layer.addSublayer(border)
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
