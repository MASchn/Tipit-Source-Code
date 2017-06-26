//
//  TIPValidator.swift
//  Ironc.ly
//

import UIKit

class TIPValidator: NSObject {
    
    class func isValidUsername(input: String) -> Bool {
        // Alphanumeric between 1 and 18 characters
        let regEx: String = "\\A\\w{1,18}\\z"
        let test: NSPredicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        return test.evaluate(with: input)
    }
    
    class func isValidEmail(input: String) -> Bool {
        let regEx: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let test: NSPredicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        return test.evaluate(with: input)
    }
    
    class func isValidPassword(input: String) -> Bool {
        if input.characters.count > 6 {
            return true
        }
        return false
    }

}
