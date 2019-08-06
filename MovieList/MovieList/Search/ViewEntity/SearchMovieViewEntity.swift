//
//  SearchMovieViewEntity.swift
//  MovieList
//
//  Created by Filipe Faria on 05/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation

struct SearchMovieViewEntity {
    let id: Int
    let title: String
    let releaseDate: String
    let posterPath: String?
    let genreList: [String]
}
