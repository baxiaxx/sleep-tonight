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
                                  backgroundColor: .stPurpleBlue,
                                  darkBackgroundColor: .stDarkPurpleBlue,
                                  primaryTextColor: .stDullBlue,
                                  accentColor: .stOffWhite)
    
    static let light = ColorTheme(isDefaultStatusBar: false,
                                  backgroundColor: .stMidnightBlue,
                                  darkBackgroundColor: .stDarkMidnightBlue,
                                  primaryTextColor: .stPaleLavender,
                                  accentColor: .stLightGray)
    
    let isDefaultStatusBar: Bool
    let backgroundColor: UIColor
    let darkBackgroundColor: UIColor
    let primaryTextColor: UIColor
    let accentColor: UIColor
    
}
