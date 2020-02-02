//
//  Trip.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 02/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//
import CoreLocation

enum RouteStatus {
    case idle
    case ongoing
    case scheduled
    case finalized
    case canceled
}

struct Trip {
    var description: String
    var driverName: String
    var startTime: String
    var endTime: String
    var routeString: String
    var routeCoords: [CLLocationCoordinate2D]
    var status: RouteStatus
    var stops: [Stop]
    var origin: MapPoint
    var destination: MapPoint
}
