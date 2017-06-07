//
//  IROShape.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 6/6/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import Foundation

struct IROShape {
    let name: String? // Used for image and animation
    let minutes: Int?
    let coins: Int?
    
    init() {
        self.name = nil
        self.minutes = nil
        self.coins = nil
    }
    
    init(name: String, minutes: Int, coins: Int) {
        self.name = name
        self.minutes = minutes
        self.coins = coins
    }
}
