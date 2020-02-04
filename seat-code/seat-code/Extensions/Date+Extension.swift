//
//  Date+Extension.swift
//  seat-code
//
//  Created by Daniel Castro on 03/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import Foundation

extension Date {
    func differenceHoursAndMinutes(between otherDate: Date) -> DateComponents {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: self, to: otherDate)
        return components
    }

    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
