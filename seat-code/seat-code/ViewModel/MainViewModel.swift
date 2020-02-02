//
//  MainViewModel.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 02/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftyJSON

class MainViewModel {
    // MARK: - Constants
    
    private let resourcesApi: ResourcesApi
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    init(resourcesApi: ResourcesApi) {
        self.resourcesApi = resourcesApi
        // subscribes()
        self.getTrips()
    }
    
    // MARK: - Public methods
    
    public func getTrips() {
        resourcesApi.getTrips { result in
            print(result)
        }
    }
}
