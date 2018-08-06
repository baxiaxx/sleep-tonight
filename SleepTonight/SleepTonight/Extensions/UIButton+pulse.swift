//
//  UIButton+pulse.swift
//  SleepTonight
//
//  Created by Binjia Chen on 8/6/18.
//

import UIKit

extension UIButton {
    
    func pulse() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.1
        pulse.fromValue = 0.98
        pulse.toValue = 1.0
        pulse.autoreverses = false
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.8
        pulse.damping = 1.0
        
        self.layer.add(pulse, forKey: nil)
    }
    
}
