//
//  DataProvider.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 02/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import SwiftyJSON

// MARK: - enums

enum DataResult {
    case success(JSON)
    case failure(DataError)
}

enum DataError: Error {
    case unknownError
    case connectionError
    case authorizationError(JSON)
    case authorizationFailed(String)
    case invalidRequest
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
}

// MARK: - Protocol definition

protocol DataProvider {
     func getData(completion: @escaping (DataResult) -> Void)
}
