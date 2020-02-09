//
//  ResourcesApiTests.swift
//  seat-codeTests
//
//  Created by Daniel Castro on 09/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import SwiftyJSON

@testable import seat_code

class ResourcesApiTests: QuickSpec {
    override func spec() {
        let networkMock: NetworkProviderMock = NetworkProviderMock(baseURL: "baseUrl")
        let resourceApi: ResourcesApi = ResourcesApi(dataProvider: networkMock)

        let resultSuccess: DataResult = DataResult.success(["result": "ok"])
        let resultFail: DataResult = DataResult.failure(DataError.invalidResponse)

        describe("ResourcesApiSpec") {
            context("when ResourceApi is created") {
                it("should set dataProvider") {
                    expect(resourceApi.dataProvider.baseURL).to(equal(networkMock.baseURL))
                }
            }

            context("when getTrips is called") {
                it("should call dataProvider getData()") {
                    resourceApi.getTrips { _ in }
                    expect(networkMock.getDataCalled).to(beTrue())
                }

                it("should return DataResult.success") {
                    networkMock.returnResult = resultSuccess
                    var result: JSON = JSON()
                    resourceApi.getTrips { requestResult in
                        switch requestResult {
                        case .success(let json):
                            result = json
                        case .failure( _): break
                        }
                    }
                    expect(result["result"]).to(equal("ok"))
                }
                
                it("should return DataResult.failure") {
                    networkMock.returnResult = resultFail
                    var result: DataError = DataError.serverError
                    resourceApi.getTrips { requestResult in
                        switch requestResult {
                        case .success(_): break
                        case .failure( let failure):
                            result = failure
                        }
                    }
                    expect(result.localizedDescription).to(equal(DataError.invalidResponse.localizedDescription))
                }
            }

            context("when getStopInfo is called") {
                it("should call dataProvider getData()") {
                    resourceApi.getStopInfo(id: 0) { _ in }
                    expect(networkMock.getDataCalled).to(beTrue())
                }
            }
        }
    }
}
