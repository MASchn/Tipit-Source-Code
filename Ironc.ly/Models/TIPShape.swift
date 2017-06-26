//
//  TIPShape.swift
//  Ironc.ly
//

import Foundation

struct TIPShape {
    let name: String? // Used for image and animation
    let minutes: Int
    let coins: Int
    
    init() {
        self.name = nil
        self.minutes = 0
        self.coins = 0
    }
    
    init(name: String, minutes: Int, coins: Int) {
        self.name = name
        self.minutes = minutes
        self.coins = coins
    }
}
