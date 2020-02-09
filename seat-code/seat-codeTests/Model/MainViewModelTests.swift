//
//  MainViewModelTests.swift
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

class MainViewModelTest: QuickSpec {
    override func spec() {
        let resourcesApiMock = ResourcesApiMock(dataProvider: NetworkProviderMock(baseURL: "https://europe-west1-metropolis-fe-test.cloudfunctions.net/api/"))

        let successJSON: JSON = [["description": "Barcelona a Martorell", "route": "sdq[Fc]iLj@zR|W~TryCzvC??do@jkKeiDxjIccLhiFqiE`uJqe@rlCy~B`t@sK|i@", "endTime": "2018-12-18T09:00:00.000Z", "stops": [["id": 1, "point": ["_latitude": 41.376530000000002, "_longitude": 2.1792400000000001]], ["id": 2, "point": ["_longitude": 2.1549399999999999, "_latitude": 41.351790000000001]], ["id": 3, "point": ["_longitude": 2.0009399999999999, "_latitude": 41.43853]], ["id": 4, "point": ["_longitude": 1.9184300000000001, "_latitude": 41.477110000000003]]], "destination": ["address": "Seat HQ, Martorell", "point": ["_latitude": 41.499580000000002, "_longitude": 1.90307]], "status": "ongoing", "origin": ["point": ["_latitude": 41.380740000000003, "_longitude": 2.18594], "address": "Metropolis:lab, Barcelona"], "driverName": "Alberto Morales", "startTime": "2018-12-18T08:00:00.000Z"]]

        let failJSON: JSON = [["description": "Barcelona a Martorell", "stops": [["id": 1, "point": ["_latitude": 41.376530000000002, "_longitude": 2.1792400000000001]], ["id": 2, "point": ["_longitude": 2.1549399999999999, "_latitude": 41.351790000000001]], ["id": 3, "point": ["_longitude": 2.0009399999999999, "_latitude": 41.43853]], ["id": 4, "point": ["_longitude": 1.9184300000000001, "_latitude": 41.477110000000003]]], "destination": ["address": "Seat HQ, Martorell", "point": ["_latitude": 41.499580000000002, "_longitude": 1.90307]], "status": "ongoing", "origin": ["point": ["_latitude": 41.380740000000003, "_longitude": 2.18594], "address": "Metropolis:lab, Barcelona"], "driverName": "Alberto Morales", "startTime": "2018-12-18T08:00:00.000Z"]]
        
        let failJSONTypeMismatch: JSON = [["description": 1, "route": "sdq[Fc]iLj@zR|W~TryCzvC??do@jkKeiDxjIccLhiFqiE`uJqe@rlCy~B`t@sK|i@", "endTime": "2018-12-18T09:00:00.000Z", "stops": [["id": 1, "point": ["_latitude": 41.376530000000002, "_longitude": 2.1792400000000001]], ["id": 2, "point": ["_longitude": 2.1549399999999999, "_latitude": 41.351790000000001]], ["id": 3, "point": ["_longitude": 2.0009399999999999, "_latitude": 41.43853]], ["id": 4, "point": ["_longitude": 1.9184300000000001, "_latitude": 41.477110000000003]]], "destination": ["address": "Seat HQ, Martorell", "point": ["_latitude": 41.499580000000002, "_longitude": 1.90307]], "status": "ongoing", "origin": ["point": ["_latitude": 41.380740000000003, "_longitude": 2.18594], "address": "Metropolis:lab, Barcelona"], "driverName": "Alberto Morales", "startTime": "2018-12-18T08:00:00.000Z"]]
        
        let failJSONValueNotFound: JSON = [["description": nil, "route": "sdq[Fc]iLj@zR|W~TryCzvC??do@jkKeiDxjIccLhiFqiE`uJqe@rlCy~B`t@sK|i@", "endTime": "2018-12-18T09:00:00.000Z", "stops": [["id": 1, "point": ["_latitude": 41.376530000000002, "_longitude": 2.1792400000000001]], ["id": 2, "point": ["_longitude": 2.1549399999999999, "_latitude": 41.351790000000001]], ["id": 3, "point": ["_longitude": 2.0009399999999999, "_latitude": 41.43853]], ["id": 4, "point": ["_longitude": 1.9184300000000001, "_latitude": 41.477110000000003]]], "destination": ["address": "Seat HQ, Martorell", "point": ["_latitude": 41.499580000000002, "_longitude": 1.90307]], "status": "ongoing", "origin": ["point": ["_latitude": 41.380740000000003, "_longitude": 2.18594], "address": "Metropolis:lab, Barcelona"], "driverName": "Alberto Morales", "startTime": "2018-12-18T08:00:00.000Z"]]

        let getTripsSuccess: DataResult = DataResult.success(successJSON)
        let getTripsParseFail: DataResult = DataResult.success(failJSON)
        
        let getTripsParseFailTypeMismatch: DataResult = DataResult.success(failJSONTypeMismatch)
        let getTripsParseFailValueNotFound: DataResult = DataResult.success(failJSONValueNotFound)

        let getTripsInvalidResponse: DataResult = DataResult.failure(.invalidResponse)
        let getTripsServerErrorResponse: DataResult = DataResult.failure(.serverError)
        let getTripsUnknownErrorResponse: DataResult = DataResult.failure(.unknownError)

        let viewModel = MainViewModel(resourcesApi: resourcesApiMock)

        describe("MainViewModelSpec") {
            context("when viewModel getTrips is called") {
                it("should call resourcesApi getTrips") {
                    viewModel.getTrips()
                    expect(resourcesApiMock.getTripsCalled).to(beTrue())
                }

                it("should set trips correct value") {
                    var trips: [Trip] = []
                    let expectation = self.expectation(description: "Getting trips")
                    let subscription = viewModel.trips.subscribe(onNext: { _trips in
                        trips = _trips
                        expectation.fulfill()
                    })
                    resourcesApiMock.returnResult = getTripsSuccess
                    viewModel.getTrips()
                    self.waitForExpectations(timeout: 1, handler: nil)
                    expect(trips.count).to(equal(1))
                    subscription.dispose()
                }

                it("should set trips incorrect value") {
                    var requestError: String = ""
                    let expectation = self.expectation(description: "Getting trips")
                    let subscription = viewModel.requestError.subscribe(onNext: { _requestError in
                        requestError = _requestError
                        expectation.fulfill()
                    })
                    resourcesApiMock.returnResult = getTripsParseFail
                    viewModel.getTrips()
                    self.waitForExpectations(timeout: 1, handler: nil)
                    expect(requestError).to(equal("Tenemos problemas en nuestro servicio, por favor inténtalo más tarde. (ERROR CODE: 1)"))
                    subscription.dispose()
                }
                
                it("should set trips mismatch value") {
                    var requestError: String = ""
                    let expectation = self.expectation(description: "Getting trips")
                    let subscription = viewModel.requestError.subscribe(onNext: { _requestError in
                        requestError = _requestError
                        expectation.fulfill()
                    })
                    resourcesApiMock.returnResult = getTripsParseFailTypeMismatch
                    viewModel.getTrips()
                    self.waitForExpectations(timeout: 1, handler: nil)
                    expect(requestError).to(equal("Tenemos problemas en nuestro servicio, por favor inténtalo más tarde. (ERROR CODE: 1)"))
                    subscription.dispose()
                }
                
                it("should set trips not found value") {
                    var requestError: String = ""
                    let expectation = self.expectation(description: "Getting trips")
                    let subscription = viewModel.requestError.subscribe(onNext: { _requestError in
                        requestError = _requestError
                        expectation.fulfill()
                    })
                    resourcesApiMock.returnResult = getTripsParseFailValueNotFound
                    viewModel.getTrips()
                    self.waitForExpectations(timeout: 1, handler: nil)
                    expect(requestError).to(equal("Tenemos problemas en nuestro servicio, por favor inténtalo más tarde. (ERROR CODE: 1)"))
                    subscription.dispose()
                }

                it("should return invalidResponse error") {
                    var requestError: String = ""
                    let expectation = self.expectation(description: "Getting trips")
                    let subscription = viewModel.requestError.subscribe(onNext: { _requestError in
                        requestError = _requestError
                        expectation.fulfill()
                    })
                    resourcesApiMock.returnResult = getTripsInvalidResponse
                    viewModel.getTrips()
                    self.waitForExpectations(timeout: 1, handler: nil)
                    expect(requestError).to(equal("No hemos podido cargar las rutas, por favor inténtalo más tarde."))
                    subscription.dispose()
                }

                it("should return serverError error") {
                    var requestError: String = ""
                    let expectation = self.expectation(description: "Getting trips")
                    let subscription = viewModel.requestError.subscribe(onNext: { _requestError in
                        requestError = _requestError
                        expectation.fulfill()
                    })
                    resourcesApiMock.returnResult = getTripsServerErrorResponse
                    viewModel.getTrips()
                    self.waitForExpectations(timeout: 1, handler: nil)
                    expect(requestError).to(equal("Tenemos problemas en nuestro servicio, por favor inténtalo más tarde. (ERROR CODE: 2)"))
                    subscription.dispose()
                }

                it("should return UnknownError error") {
                    var requestError: String = ""
                    let expectation = self.expectation(description: "Getting trips")
                    let subscription = viewModel.requestError.subscribe(onNext: { _requestError in
                        requestError = _requestError
                        expectation.fulfill()
                    })
                    resourcesApiMock.returnResult = getTripsUnknownErrorResponse
                    viewModel.getTrips()
                    self.waitForExpectations(timeout: 1, handler: nil)
                    expect(requestError).to(equal("Se ha producido un error, por favor inténtalo más tarde."))
                    subscription.dispose()
                }
            }
        }
    }
}
