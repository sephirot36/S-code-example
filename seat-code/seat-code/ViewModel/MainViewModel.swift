//
//  MainViewModel.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 02/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import GoogleMaps
import Polyline
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
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.parseDateFormat)
                
                do {
                    let tmpTrips: [Trip] = try decoder.decode([Trip].self, from: json.rawData())
                    var parsedTrips: [Trip] = []
                    for trip in tmpTrips {
                        let coords: [CLLocationCoordinate2D] = self.getTripCoords(route: trip.route)
                        var tmpTrip = trip
                        tmpTrip.coords = coords
                        tmpTrip.stops = self.cleanStopsArray(stops: trip.stops)
                        parsedTrips.append(tmpTrip)
                    }
                    
                    self.trips.onNext(parsedTrips)
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                    self.requestError.onNext("Tenemos problemas en nuestro servicio, por favor inténtalo más tarde. (ERROR CODE: 1)")
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    self.requestError.onNext("Tenemos problemas en nuestro servicio, por favor inténtalo más tarde. (ERROR CODE: 1)")
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    self.requestError.onNext("Tenemos problemas en nuestro servicio, por favor inténtalo más tarde. (ERROR CODE: 1)")
                } catch let DecodingError.typeMismatch(type, context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    self.requestError.onNext("Tenemos problemas en nuestro servicio, por favor inténtalo más tarde. (ERROR CODE: 1)")
                } catch {
                    print("error: ", error)
                    self.requestError.onNext("Tenemos problemas en nuestro servicio, por favor inténtalo más tarde. (ERROR CODE: 1)")
                }
            case .failure(let failure):
                switch failure {
                case .invalidResponse:
                    self.requestError.onNext("No hemos podido cargar las rutas, por favor inténtalo más tarde.")
                case .serverError:
                    self.requestError.onNext("Tenemos problemas en nuestro servicio, por favor inténtalo más tarde. (ERROR CODE: 2)")
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
    
    private func getTripCoords(route: String) -> [CLLocationCoordinate2D] {
        return decodePolyline(route) ?? []
    }
    
    private func cleanStopsArray(stops: [TripStop]) -> [TripStop] {
        var tmpStops: [TripStop] = []
        for stop in stops {
            if let id = stop.id, let point = stop.point {
                tmpStops.append(TripStop(id: id, point: point))
            }
        }
        return tmpStops
    }
}
