//
//  UIButton.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 9/27/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit

public extension UIButton {
    
    override var intrinsicContentSize: CGSize {
        return self.titleLabel!.intrinsicContentSize
    }
    
    // Whever the button is changed or needs to layout subviews,
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.preferredMaxLayoutWidth = self.titleLabel!.frame.size.width
    }
}
