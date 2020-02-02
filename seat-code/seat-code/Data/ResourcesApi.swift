//
//  ResourcesApi.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 02/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import SwiftyJSON

class ResourcesApi {
    // MARK: - Constants
    
    let dataProvider: NetworkProvider
    
    // MARK: - Initializer
    
    init(dataProvider: NetworkProvider) {
        self.dataProvider = dataProvider
    }
    
    // MARK: - Public methods
    
    public func getTrips(result: @escaping (DataResult) -> Void) {
        dataProvider.endPoint = "trips"
        dataProvider.httpMethod = .get
        dataProvider.getData {
            returnResult in
            result(returnResult)
            //print("RESULT:\(result)")
        }
    }
}
