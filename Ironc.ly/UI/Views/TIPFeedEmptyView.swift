//
//  TIPFeedEmptyView.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 7/1/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class TIPFeedEmptyView: TIPEmptyStateView {
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.iconImageView.image = #imageLiteral(resourceName: "no_stories")
        self.titleLabel.text = "No stories"
        self.subtitleLabel.text = "Take pictures, record videos. Your story will appear here.\nOr find users to follow and see their stories."
        self.actionButton.setTitle("Follow", for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
