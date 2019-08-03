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
    
    func request(request: Request, callback: @escaping (_ data: Data?, _ error: Error? )-> Void) {
        
        Alamofire.request(request.endPoint,
                          method: request.method,
                          parameters: request.queryItems,
                          encoding: request.paramenterEncoding,
                          headers: request.header).responseJSON { response in
                            
                            callback(response.data, response.error)
        }
    }
}
