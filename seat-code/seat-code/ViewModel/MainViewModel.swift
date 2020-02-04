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
    // MARK: - Constants
    
    private let resourcesApi: ResourcesApi
    private let disposeBag = DisposeBag()
    
    let trips = PublishSubject<[Trip]>()
    let isLoading = PublishSubject<Bool>()
    let requestError = PublishSubject<String>()
    
    // MARK: - Initializer
    
    init(resourcesApi: ResourcesApi) {
        self.resourcesApi = resourcesApi
        // subscribes()
        getTrips()
    }
    
    // MARK: - Public methods
    
    public func getTrips() {
        isLoading.onNext(true)
        resourcesApi.getTrips { [weak self]
            result in
            guard let `self` = self else { return }
            switch result {
            case .success(let json):
                let tmpTrips = json.arrayValue.compactMap {
                    Trip(description: $0["description"].stringValue,
                         driverName: $0["driverName"].stringValue,
                         startTime: $0["startTime"].stringValue.toDate(),
                         endTime: $0["endTime"].stringValue.toDate(),
                         routeString: $0["route"].stringValue,
                         routeCoords: self.getTripCoords(trip: $0),
                         status: self.getTripStatus(trip: $0),
                         stops: self.getTripStops(trip: $0),
                         origin: self.getTripOrigin(trip: $0),
                         destination: self.getTripDestination(trip: $0))
                }
                self.trips.onNext(tmpTrips)
            case .failure(let failure):
                switch failure {
                case .invalidResponse:
                    self.requestError.onNext("No hemos podido cargar las rutas, por favor inténtalo más tarde.")
                case .serverError:
                    self.requestError.onNext("Tenemos problemas en nuestro servicio, por favor inténtalo más tarde")
                case .unknownError:
                    self.requestError.onNext("Se ha producido un error, por favor inténtalo más tarde.")
                default:
                    self.requestError.onNext("No hemos podido cargar las rutas, por favor inténtalo más tarde.")
                }
            }
            self.isLoading.onNext(false)
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
