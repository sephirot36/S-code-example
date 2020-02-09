//
//  String+Extension.swift
//  seat-code
//
//  Created by Daniel Castro on 03/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import Foundation

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "Europe/London")
        dateFormatter.locale = Locale(identifier: "en_US")
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }
}
