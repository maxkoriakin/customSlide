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
    var sliderColor: UIColor = .green
    var fillSliderColor: UIColor = .blue
    
    var maxValue: CGFloat = 900
    var minValue: CGFloat = 10
    var startPoint: CGFloat = 0.0
    
    private let indicatorViewHeight: CGFloat = 1
    
    @IBInspectable var selectedValue: CGFloat {
        set {
            setupIndicatorPosition()
            _selectedValue = newValue
        }
        get {
            return _selectedValue
        }
    }
    
    // MARK: - Computed Properties
    var containerCornerRadius: CGFloat {
        return 20
    }
    
    // MARK: - Private Properties
    private var sliderView = UIView()
    private var indicatorView = UIView()
    private var filledSliderLayer = UIView()
    
    var bottomIndicatorAnchor: NSLayoutConstraint?
    
    private var _selectedValue: CGFloat = 100
    private var selectedIndicatorPosition: CGFloat = 0.0
    
    // MARK: - Life Cycle
    init(frame: CGRect, selectedValue: CGFloat) {
        self._selectedValue = selectedValue
        
        super.init(frame: frame)
        
        self.setupSliderView()
        self.setupIndicatorView()
        self.setupGestureRecognizers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        setupControlPoints()
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
    
    func setupIndicatorView() {
        indicatorView.backgroundColor = fillSliderColor
        
        sliderView.addSubview(indicatorView)
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        indicatorView.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor, constant: 0.0).isActive = true
        indicatorView.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor, constant: 0.0).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: indicatorViewHeight).isActive = true
        bottomIndicatorAnchor = indicatorView.bottomAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: -selectedIndicatorPosition)
        bottomIndicatorAnchor?.isActive = true
        setupIndicatorPosition()
        
        setupFillView()
        
        layoutIfNeeded()
        setupIndicatorPosition()
    }
    
    func setupFillView() {
        filledSliderLayer.backgroundColor = fillSliderColor
        
        sliderView.addSubview(filledSliderLayer)
        
        filledSliderLayer.translatesAutoresizingMaskIntoConstraints = false
        
        filledSliderLayer.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor, constant: 0.0).isActive = true
        filledSliderLayer.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor, constant: 0.0).isActive = true
        filledSliderLayer.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 0.0).isActive = true
        filledSliderLayer.bottomAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: 0.0).isActive = true
    }
    
    private func setupGestureRecognizers() {
        let panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                                                  action: #selector(sliderPanGestureRecognizerAction))
        panGestureRecognizer.cancelsTouchesInView = false
        
        sliderView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setupIndicatorPosition() {
        let indicatorPosition = ((selectedValue - minValue) / maxValue) * sliderView.frame.height
        selectedIndicatorPosition = indicatorPosition
        
        bottomIndicatorAnchor?.constant = -indicatorPosition
    }
    
    // MARK: - Actions
    @objc private func sliderPanGestureRecognizerAction(_ panGestureRecognizer: UIPanGestureRecognizer) {
        guard panGestureRecognizer.state == .changed else { return }
        
        updateIndicatorPosition(for: panGestureRecognizer)
    }
    
    // MARK: - Helper Methods
    private func updateIndicatorPosition(for gestureRecognizer: UIGestureRecognizer) {
        let location: CGPoint = gestureRecognizer.location(in: sliderView)
        let position: CGFloat = sliderView.frame.height - location.y + indicatorView.frame.height / 2
        let indicatorPosition: CGFloat = position > sliderView.frame.height ? sliderView.frame.height : position
//        let maxIndicatorPosition: CGFloat = sliderView.frame.height - height(for: minValue)
//        let newIndicatorPosition: CGFloat = max(min(indicatorPosition, maxIndicatorPosition), 0)
//        selectedIndicatorPosition = newIndicatorPosition
        selectedIndicatorPosition = indicatorPosition

        bottomIndicatorAnchor?.constant = -indicatorPosition
        
        layoutIfNeeded()
        
//        changeToSelectedPosition()
    }
    
//    private func selectedValue(for indicatorPosition: CGFloat) -> CGFloat {
//        let relatedMinValue: CGFloat = (minValue / (maxValue - minValue)) * sliderView.frame.height
//
//        var progress: CGFloat
//        if indicatorPosition > 0 {
//            progress = (indicatorPosition + relatedMinValue) / sliderView.frame.height
//        } else {
//            progress = relatedMinValue / sliderView.frame.height
//        }
//
//        if progress > 1 {
//            progress = 1
//        }
//
//        let selectedValue: CGFloat = maxValue * progress
//
//        return selectedValue
//    }
//
//    private func changeToSelectedPosition() {
//        indicatorView.bottomAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: -selectedIndicatorPosition).isActive = true
//
//        let newSelectedValue: CGFloat = selectedValue(for: selectedIndicatorPosition)
//        _selectedValue = newSelectedValue
//    }
}

// MARK: - UIGestureRecognizerDelegate
extension Slider: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
