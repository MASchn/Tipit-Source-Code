//
//  TIPSearchEmptyView.swift
//  Ironc.ly
//
//  Created by Alex Laptop on 8/11/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class TIPSearchEmptyView: TIPEmptyStateView {
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.iconImageView.image = #imageLiteral(resourceName: "no_stories")
        self.titleLabel.text = "No results"
        //self.subtitleLabel.text = "Take pictures, record videos. Your story will appear here.\nOr find users to follow and see their stories."
        //self.actionButton.setTitle("Follow", for: .normal)
        self.actionButton.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
