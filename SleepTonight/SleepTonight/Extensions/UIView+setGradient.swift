//
//  UIView+setGradient.swift
//  SleepTonight
//
//  Created by Binjia Chen on 8/7/18.
//

import UIKit

extension UIView {
    
    func setGradient(_ color1: UIColor, _ color2: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.layer.bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        self.layer.insertSublayer(gradientLayer, below: self.subviews[0].layer)
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        
        gradientLayer.add(animation, forKey: "opacity")
        
    }
    
}
