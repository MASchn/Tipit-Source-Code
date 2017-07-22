//
//  Date+Tipit.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 7/22/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import Foundation

extension Date {
    
    // Cosmo did some crazy shit here
    // The way to calculate the time remaining is created_at - (now - 24 hours)
    static func fromString(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: dateString)!
    }
    
    func timeRemaining() -> DateComponents {
        let now: Date = Date()
        let yesterday: Date = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        return Calendar.current.dateComponents([.day, .hour, .minute], from: yesterday, to: self)
    }
    
    func formattedTimeRemaining() -> String {
        let timeRemaining: DateComponents = self.timeRemaining()
        if timeRemaining.day! > 0 {
            return "\(timeRemaining.day!)d left"
        } else {
            return "\(timeRemaining.hour!)h left"
        }
    }
    
}
