//
//  Date+convertToString.swift
//  SleepTonight
//
//  Created by Binjia Chen on 7/24/18.
//

import Foundation

extension Date {
    func convertToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }
}
