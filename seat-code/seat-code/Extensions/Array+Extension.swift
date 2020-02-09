//
//  Array+Extension.swift
//  seat-code
//
//  Created by Daniel Castro on 05/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import Foundation

extension Array {
    func firstMatchingType<Type>() -> Type? {
        return first(where: { $0 is Type }) as? Type
    }
}
