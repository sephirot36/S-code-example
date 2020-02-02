//
//  NetworkProvider.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 02/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import Alamofire
import RxCocoa
import RxSwift
import SwiftyJSON

// MARK: - enums

enum HTTPMethod: String {
    case get = "GET"
}

class NetworkProvider: DataProvider {
    // MARK: - Constants

    let baseURL: String

    // MARK: - Variables

    var endPoint: String = ""
    var httpMethod: HTTPMethod = .get

    // MARK: - Typealias

    typealias parameters = [String: Any]
    typealias headers = [String: String]

    // MARK: - Initialization

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    // MARK: - Protocol conforming

    func getData(completion: @escaping (DataResult) -> Void) {
        requestData(endpoint: endPoint, method: httpMethod) {
            result in
            completion(result)
        }
    }

    // MARK: - Private methods

    func requestData(endpoint: String, method: HTTPMethod, completion: @escaping (DataResult) -> Void) {
        let urlRequest = URLRequest(url: URL(string: baseURL + endpoint)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)

        Alamofire.request(urlRequest).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let responseJson = JSON(value)
                completion(DataResult.success(responseJson))
            case .failure:
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 400...499:
                        completion(DataResult.failure(.serverError))
                    case 500...599:
                        completion(DataResult.failure(.serverError))
                    default:
                        completion(DataResult.failure(.unknownError))
                    }
                }
            }
        }
    }
}
