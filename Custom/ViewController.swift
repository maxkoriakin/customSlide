//
//  ViewController.swift
//  Custom
//
//  Created by Max Koriakin on 5/7/19.
//  Copyright © 2019 Max Koriakin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMirrorSlider()
        addOneSideSlider()
    }

    
    func addMirrorSlider() {
        let slider = MirrorSlider(frame: CGRect(x: 300.0, y: 100.0, width: 50.0, height: 200.0), selectedValue: 500)
        self.view.addSubview(slider)
    }
    
    func addOneSideSlider() {
        let slider = OneSideSlider(frame: CGRect(x: 100, y: 100.0, width: 50.0, height: 200.0), selectedValue: 500)
        self.view.addSubview(slider)
    }
}

