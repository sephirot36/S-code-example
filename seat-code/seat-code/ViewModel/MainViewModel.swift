//
//  MainViewModel.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 02/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import GoogleMaps
import RxCocoa
import RxSwift
import SwiftyJSON

class MainViewModel {
    // MARK: - Variables
    
    var trips = PublishSubject<[Trip]>()
    
    // MARK: - Constants
    
    private let resourcesApi: ResourcesApi
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    init(resourcesApi: ResourcesApi) {
        self.resourcesApi = resourcesApi
        // subscribes()
        getTrips()
    }
    
    // MARK: - Public methods
    
    public func getTrips() {
        resourcesApi.getTrips { [weak self]
            result in
            switch result {
            case .success(let json):
                let tmpTrips = json.arrayValue.compactMap {
                    Trip(description: $0["description"].stringValue,
                         driverName: $0["driverName"].stringValue,
                         startTime: $0["startTime"].stringValue,
                         endTime: $0["endTime"].stringValue,
                         routeString: $0["route"].stringValue,
                         routeCoords: self!.getTripCoords(trip: $0),
                         status: self!.getTripStatus(trip: $0),
                         stops: self!.getTripStops(trip: $0),
                         origin: self!.getTripOrigin(trip: $0),
                         destination: self!.getTripDestination(trip: $0))
                }
                self!.trips.onNext(tmpTrips)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func getTripCoords(trip: JSON) -> [CLLocationCoordinate2D] {
        return []
    }
    
    private func getTripStatus(trip: JSON) -> RouteStatus {
        var status: RouteStatus
        
        switch trip["status"].stringValue {
        case "ongoing":
            status = .ongoing
        case "scheduled":
            status = .scheduled
        case "finalized":
            status = .finalized
        case "cancelled":
            status = .canceled
        default:
            status = .idle
        }
        return status
    }
    
    private func getTripStops(trip: JSON) -> [Stop] {
        let stops = trip["stops"].arrayValue.compactMap { _ in
            Stop(id: trip["id"].intValue, stopTime: "", paid: false,
                 point: MapPoint(point: Point(latitude: trip["_latitude"].floatValue, longitude: trip["_longitude"].floatValue), address: ""),
                 tripId: 0, username: "", price: 0.0)
        }
        
        return stops
    }
    
    private func getTripOrigin(trip: JSON) -> MapPoint {
        let origin = MapPoint(point: Point(latitude: trip["origin"]["point"]["_latitude"].floatValue,
                              longitude: trip["origin"]["point"]["_longitude"].floatValue),
                 address: trip["origin"]["address"].stringValue)
        return origin
    }
    
    private func getTripDestination(trip: JSON) -> MapPoint {
        let destination = MapPoint(point: Point(latitude: trip["destination"]["point"]["_latitude"].floatValue,
                                 longitude: trip["destination"]["point"]["_longitude"].floatValue),
                    address: trip["destination"]["address"].stringValue)
           return destination
       }
}
