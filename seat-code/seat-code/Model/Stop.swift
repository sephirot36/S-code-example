//
//  Stop.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 02/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

struct Stop: Codable {
    var tripId: Int
    var address: String
    var paid: Bool
    var stopTime: String
    var price: Float
    var userName: String
    var point: Point
}
