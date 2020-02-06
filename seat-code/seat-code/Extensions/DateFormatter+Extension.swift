//
//  DateFormatter.swift
//  seat-code
//
//  Created by Daniel Castro on 06/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let parseDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(identifier: "Europe/London")
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
}
