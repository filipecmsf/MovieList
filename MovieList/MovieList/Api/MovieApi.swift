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
    
    func requestMovieList() {
        Alamofire.request("https://api.themoviedb.org/3/movie/upcoming?api_key=1f54bd990f1cdfb230adb312546d765d&language=en-US&page=1").responseJSON { response in
            
                        if let data = response.data {
                            do {
                                let root = try JSONDecoder().decode(MovieList.self, from: data)
                                print(root)
                            } catch let error {
                                print(error)
                            }
                        }
                    }
    }
}
