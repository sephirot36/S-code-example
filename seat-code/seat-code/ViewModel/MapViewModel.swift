//
//  MapViewModel.swift
//  seat-code
//
//  Created by Daniel Castro on 05/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//
import RxCocoa
import RxSwift

class MapViewModel {
    // MARK: - Constants
    
    private let resourcesApi: ResourcesApi
    private let disposeBag = DisposeBag()
    
    let stopInfo = PublishSubject<Stop>()
    let requestError = PublishSubject<String>()
    
    // MARK: - Initializer
    
    init(resourcesApi: ResourcesApi) {
        self.resourcesApi = resourcesApi
    }
    
    // MARK: - Public methods
    
    public func getStopInfo(id: Int) {
        resourcesApi.getStopInfo(id: id) { [weak self]
            result in
            guard let `self` = self else { return }
            switch result {
            case .success(let json):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.parseDateFormat)
                
                do {
                    let stop = try decoder.decode(Stop.self, from: json.rawData())
                    self.stopInfo.onNext(stop)
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
                print(failure)
                switch failure {
                case .invalidResponse:
                    self.requestError.onNext("No hemos podido cargar la información de la parada, por favor inténtalo más tarde.")
                case .serverError:
                    self.requestError.onNext("Tenemos problemas en nuestro servicio, por favor inténtalo más tarde. (ERROR CODE: 2)")
                case .unknownError:
                    self.requestError.onNext("Se ha producido un error, por favor inténtalo más tarde.")
                default:
                    self.requestError.onNext("No hemos podido cargar la información de la parada, por favor inténtalo más tarde.")
                }
            }
            // self.isLoading.onNext(false)
        }
    }
}
