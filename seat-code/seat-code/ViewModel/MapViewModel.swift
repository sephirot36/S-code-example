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
    
    let trips = PublishSubject<[Trip]>()
    
    // MARK: - Initializer
    
    init(resourcesApi: ResourcesApi) {
        self.resourcesApi = resourcesApi
    }
    
    // MARK: - Public methods
    
    public func getStopInfo(id: Int) {
        
    }
    
}
