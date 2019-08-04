//
//  MovieApi.swift
//  MovieList
//
//  Created by Filipe Faria on 01/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class MovieApi {
    
    class var shared : MovieApi {
        
        struct Static {
            static let instance: MovieApi = MovieApi()
        }
        return Static.instance
    }
    
    private func getServerError(error: Data?, statusCode: Int) -> ServerError {
        
        let unknownError = ServerError(statusMessage: nil, statusCode: ErrorStatusCode(rawValue: 400), errors: [NSLocalizedString("error.unknown_error", comment: "")])
        
        guard let data = error else {
            return unknownError
        }
        
        do {
            var serverError = try JSONDecoder().decode(ServerError.self, from: data)
            serverError.statusCode = ErrorStatusCode(rawValue: statusCode)
            return serverError
        } catch {
            return unknownError
        }
    }
    
    func request(request: Request, callback: @escaping (_ data: Data?, _ error: ServerError? )-> Void) {
        
        Alamofire.request(request.endPoint,
                          method: request.method,
                          parameters: request.queryItems,
                          encoding: request.paramenterEncoding,
                          headers: request.header).responseJSON { response in
                            
                            guard let statusCode = response.response?.statusCode else {
                                let error = ServerError(statusMessage: nil, statusCode: ErrorStatusCode(rawValue: 404), errors: [NSLocalizedString("error.no_internet", comment: "")])
                                callback(response.data, error)
                                return
                            }
                            switch statusCode {
                            case 200...299:
                                callback(response.data, nil)
                            default:
                                callback(nil, self.getServerError(error: response.data, statusCode: statusCode))
                            }
                            
        }
    }
}
