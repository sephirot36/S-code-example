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
                    let coords: [CLLocationCoordinate2D] = []
                    var status: RouteStatus
                    
                    switch $0["status"].stringValue {
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
                    
                    let stopsArray = $0["stops"].arrayValue.compactMap {
                        Stop(id: $0["id"].intValue, stopTime: "", paid: false,
                             point: MapPoint(point: Point(latitude: $0["_latitude"].floatValue, longitude: $0["_longitude"].floatValue), address: ""),
                             tripId: 0, username: "", price: 0.0)
                    }
                    
                    let origin = MapPoint(point: Point(latitude: $0["origin"]["point"]["_latitude"].floatValue,
                                                       longitude: $0["origin"]["point"]["_longitude"].floatValue),
                                          address: $0["origin"]["address"].stringValue)
                    
                    let destination = MapPoint(point: Point(latitude: $0["destination"]["point"]["_latitude"].floatValue,
                                                            longitude: $0["destination"]["point"]["_longitude"].floatValue),
                                               address: $0["destination"]["address"].stringValue)
                    
                    Trip(description: $0["description"].stringValue,
                         driverName: $0["driverName"].stringValue,
                         startTime: $0["startTime"].stringValue,
                         endTime: $0["endTime"].stringValue,
                         routeString: $0["route"].stringValue,
                         routeCoords: coords,
                         status: status,
                         stops: stopsArray,
                         origin: origin,
                         destination: destination)
                }
                self!.trips.onNext(tmpTrips)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
