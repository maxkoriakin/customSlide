//
//  Slider.swift
//  Custom
//
//  Created by Max Koriakin on 5/7/19.
//  Copyright © 2019 Max Koriakin. All rights reserved.
//

import UIKit

class Slider: UIView {
    
    // MARK: - Properties
    @IBInspectable var sliderColor: UIColor = .green
    @IBInspectable var fillSliderColor: UIColor = .blue
    
    @IBInspectable  var maxValue: CGFloat = 900
    @IBInspectable  var minValue: CGFloat = 10
    
    @IBInspectable var selectedPosition: CGFloat = 0.0

    var startPoint: CGFloat {
        return 0.0
    }
    
    // MARK: - Computed Properties
    var containerCornerRadius: CGFloat {
        return 20
    }
    
    // MARK: - Private Properties
    var sliderView = UIView()
    var filledSliderLayer = UIView()
    
    var topFillAnchor: NSLayoutConstraint?
    var bottomFillAnchor: NSLayoutConstraint?
    
    var selectedValue: CGFloat = 100 {
        willSet {
            if newValue < minValue {
                selectedValue = minValue
            } else if newValue > maxValue {
                selectedValue = maxValue
            }
        }
        didSet {
            setupPosition()
        }
    }
    
    // MARK: - Life Cycle
    init(frame: CGRect, selectedValue: CGFloat) {
        self.selectedValue = selectedValue
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateValues()
    }
    
    func initialize() {
        self.setupSliderView()
        setupFillView()
        self.setupGestureRecognizers()
    }
    
    // MARK: - Setup
    private func setupSliderView() {
        sliderView.backgroundColor = sliderColor
        sliderView.layer.cornerRadius = containerCornerRadius
        sliderView.clipsToBounds = true
        
        addSubview(sliderView)
        
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        
        sliderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        sliderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
        sliderView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        sliderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
    }
    
    func setupFillView() {
        filledSliderLayer.backgroundColor = fillSliderColor
        
        sliderView.addSubview(filledSliderLayer)
        
        filledSliderLayer.translatesAutoresizingMaskIntoConstraints = false
        
        filledSliderLayer.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor, constant: 0.0).isActive = true
        filledSliderLayer.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor, constant: 0.0).isActive = true
        
        bottomFillAnchor = filledSliderLayer.bottomAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: -startPoint)
        bottomFillAnchor?.isActive = true
        
        topFillAnchor = filledSliderLayer.topAnchor.constraint(equalTo: sliderView.topAnchor, constant: (sliderView.frame.height - selectedPosition))
        topFillAnchor?.isActive = true
        
        layoutIfNeeded()
        setupPosition()
    }
    
    private func setupGestureRecognizers() {
        let panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                                                  action: #selector(sliderPanGestureRecognizerAction))
        panGestureRecognizer.cancelsTouchesInView = false
        
        sliderView.addGestureRecognizer(panGestureRecognizer)
    }
    
    var valueDifferrent: CGFloat {
        return maxValue - minValue
    }
    
    var valueMultiplier: CGFloat {
        return valueDifferrent / maxValue
    }

    func setupPosition() {
        let position = (selectedValue / maxValue) * sliderView.frame.height
        selectedPosition = position
        
        topFillAnchor?.constant = (sliderView.frame.height - position)
    }
    
    // MARK: - Actions
    @objc private func sliderPanGestureRecognizerAction(_ panGestureRecognizer: UIPanGestureRecognizer) {
        guard panGestureRecognizer.state == .changed else { return }
        
        updatePosition(for: panGestureRecognizer)
    }
    
    // MARK: - Helper Methods
    func updatePosition(for gestureRecognizer: UIGestureRecognizer) {
        let location: CGPoint = gestureRecognizer.location(in: sliderView)
        let position: CGFloat = sliderView.frame.height - location.y
        let indicatorPosition: CGFloat = position > sliderView.frame.height ? sliderView.frame.height : position
        selectedPosition = indicatorPosition

        topFillAnchor?.constant = (sliderView.frame.height - indicatorPosition)
        
        layoutIfNeeded()        
    }
    
    func updateValues() {
        sliderView.backgroundColor = sliderColor
        filledSliderLayer.backgroundColor = fillSliderColor
        setupPosition()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension Slider: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
