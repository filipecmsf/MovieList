//
//  ServerError.swift
//  MovieList
//
//  Created by Filipe Faria on 04/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation

enum ErrorStatusCode: Int, Decodable {
    case badRequest = 400
    case notFound = 404
    case unprocessableEntity = 422
    case internalServerError = 500
}

struct ServerError: Decodable {
    let statusMessage: String?
    var statusCode: ErrorStatusCode?
    let errors: [String]?
    
    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
        case errors = "errors"
    }
}
