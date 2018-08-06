//
//  ColorTheme.swift
//  SleepTonight
//
//  Created by Selena Sui on 8/1/18.
//

import Foundation
import UIKit

struct ColorTheme {
    
    static let dark = ColorTheme(isDefaultStatusBar: true,
                                  backgroundColor: .stMidnightBlue,
                                  primaryTextColor: .stDullBlue,
                                  accentColor: .stOffWhite)
    
    static let light = ColorTheme(isDefaultStatusBar: false,
                                  backgroundColor: .stSkyBlue,
                                  primaryTextColor: .stNavy,
                                  accentColor: .stLightGray)
    
    let isDefaultStatusBar: Bool
    let backgroundColor: UIColor
    
    let primaryTextColor: UIColor
    
    let accentColor: UIColor
    
}
