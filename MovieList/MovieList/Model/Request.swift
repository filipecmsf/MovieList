//
//  Request.swift
//  MovieList
//
//  Created by Filipe Faria on 01/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation
import Alamofire

struct Request {
    let endPoint: String
    let method: HTTPMethod
    let queryItems: [String: String]
    let paramenterEncoding: ParameterEncoding? = JSONEncoding.default
    let header: HTTPHeaders?
}
