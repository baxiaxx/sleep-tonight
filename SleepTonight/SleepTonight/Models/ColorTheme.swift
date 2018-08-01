//
//  ColorTheme.swift
//  SleepTonight
//
//  Created by Binjia Chen on 8/1/18.
//

import Foundation
import UIKit

struct ColorTheme {
    
    static let dark = ColorTheme(isDefaultStatusBar: true,
                                  backgroundColor: .stMidnightBlue,
                                  primaryTextColor: .stDullBlue,
                                  secondaryColor: .stGrayBlue,
                                  secondaryTextColor: .stDarkLavender,
                                  accentColor: .stDarkMauve)
    
    static let light = ColorTheme(isDefaultStatusBar: false,
                                  backgroundColor: .stSkyBlue,
                                  primaryTextColor: .stNavy,
                                  secondaryColor: .stWarmBeige,
                                  secondaryTextColor: .stSoothingBlue,
                                  accentColor: .stCider)
    
    let isDefaultStatusBar: Bool
    let backgroundColor: UIColor
    
    let primaryTextColor: UIColor
    
    let secondaryColor: UIColor
    let secondaryTextColor: UIColor
    
    let accentColor: UIColor
    
}
