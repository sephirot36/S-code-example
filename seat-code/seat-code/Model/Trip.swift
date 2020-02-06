//
//  Trip.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 02/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//
import CoreLocation

enum RouteStatus: String {
    case idle
    case ongoing
    case scheduled
    case finalized
    case canceled
}


// TODO: How to var coords: [CLLocationCoordinate2D]? can conform Decodable?
struct Trip: Codable {
    var destination: TripLocation
    var endTime: Date
    var startTime: Date
    var description: String
    var driverName: String
    var route: String
    var status: String
    var origin: TripLocation
    var stops: [TripStop]
    var coords: [CLLocationCoordinate2D]?
}

struct TripStop: Codable {
    var id: Int?
    var point: Point?
}

struct TripLocation: Codable {
    var address: String
    var point: Point
}

extension CLLocationCoordinate2D: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(longitude)
        try container.encode(latitude)
    }
     
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let longitude = try container.decode(CLLocationDegrees.self)
        let latitude = try container.decode(CLLocationDegrees.self)
        self.init(latitude: latitude, longitude: longitude)
    }
}
