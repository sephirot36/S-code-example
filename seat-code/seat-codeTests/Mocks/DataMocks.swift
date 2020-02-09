//
//  DataMocks.swift
//  seat-codeTests
//
//  Created by Daniel Castro on 09/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

@testable import seat_code

class ResourcesApiMock: ResourcesApi {
    var getTripsCalled: Bool = false
    var getStopInfoCalled: Bool = false

    var returnResult: DataResult = DataResult.failure(DataError.notFound)

    override func getTrips(result: @escaping (DataResult) -> Void) {
        getTripsCalled = true
        result(returnResult)
    }

    override func getStopInfo(id: Int, result: @escaping (DataResult) -> Void) {
        getStopInfoCalled = true
        result(returnResult)
    }
}

class NetworkProviderMock: NetworkProvider {
    var returnResult: DataResult = DataResult.failure(DataError.notFound)
    override func getData(completion: @escaping (DataResult) -> Void) {
        completion(returnResult)
    }
}
