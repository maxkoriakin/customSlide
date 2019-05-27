//
//  MirrorSlider.swift
//  Custom
//
//  Created by Max Koriakin on 5/8/19.
//  Copyright © 2019 Max Koriakin. All rights reserved.
//

import UIKit

class MirrorSlider: Slider {

    override var startPoint: CGFloat {
        return self.frame.height / 2
    }
    
    override func setupPosition() {
        let position = (selectedValue / maxValue) * sliderView.frame.height
        selectedPosition = position
        
        topFillAnchor?.constant = (sliderView.frame.height - position)
        bottomFillAnchor?.constant = -(sliderView.frame.height - position)
    }
    
    
    // MARK: - Helper Methods
    override func updatePosition(for gestureRecognizer: UIGestureRecognizer) {
        let location: CGPoint = gestureRecognizer.location(in: sliderView)
        let position: CGFloat = sliderView.frame.height - location.y
        let indicatorPosition: CGFloat = position > sliderView.frame.height ? sliderView.frame.height : position
        selectedPosition = indicatorPosition
        
        topFillAnchor?.constant = (sliderView.frame.height - indicatorPosition)
        bottomFillAnchor?.constant = -(sliderView.frame.height - indicatorPosition)
        
        layoutIfNeeded()        
    }
}
