//
//  Movie.swift
//  MovieList
//
//  Created by Filipe Faria on 01/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let title: String
    let voteAverage: Float
    let popularity: Float
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let genreIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case voteAverage = "vote_average"
        case popularity = "popularity"
        case originalTitle = "original_title"
        case overview = "overview"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
    }
}
