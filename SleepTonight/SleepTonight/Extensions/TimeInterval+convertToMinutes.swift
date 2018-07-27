//
//  TimeInterval+convertToMinutes.swift
//  SleepTonight
//
//  Created by Binjia Chen on 7/26/18.
//

import Foundation

extension TimeInterval {
    func convertToMinutes() -> TimeInterval {
        return self * 60
    }
}
