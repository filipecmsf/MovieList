//
//  MainRepositoryMock.swift
//  MovieListTests
//
//  Created by Filipe Faria on 04/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation
@testable import MovieList

class MainRepositoryMock: MainRepositoryProtocol {
    
    var showMovieError: Bool = false
    var showGenreError: Bool = false
    var showSearchError: Bool = false
    var clearData: Bool = false
    
    func getGenres(callback: @escaping (GenreList?, String?) -> Void) {
        if showGenreError {
            callback(nil, "error")
        } else {
            callback(GenreList(genres: [Genre(id: 1, name: "")]), nil)
        }
    }
    
    func getMovies(callback: @escaping (MovieList?, String?, Bool) -> Void) {
        
        if showMovieError {
            callback(nil, "error", clearData)
        } else {
            let movies = [Movie(id: 1, title: "movie1", voteAverage: 10, popularity: 10, originalTitle: "", overview: "", posterPath: nil, releaseDate: "", genreIds: [1]),
                          Movie(id: 2, title: "movie2", voteAverage: 10, popularity: 10, originalTitle: "", overview: "", posterPath: nil, releaseDate: "", genreIds: [1]),
                          Movie(id: 3, title: "movie3", voteAverage: 10, popularity: 10, originalTitle: "", overview: "", posterPath: nil, releaseDate: "", genreIds: [1]),
                          Movie(id: 4, title: "movie4", voteAverage: 10, popularity: 10, originalTitle: "", overview: "", posterPath: nil, releaseDate: "", genreIds: [1]),
                          Movie(id: 5, title: "movie5", voteAverage: 10, popularity: 10, originalTitle: "", overview: "", posterPath: nil, releaseDate: "", genreIds: [1]),
                          Movie(id: 6, title: "movie6", voteAverage: 10, popularity: 10, originalTitle: "", overview: "", posterPath: nil, releaseDate: "", genreIds: [1]),
                          Movie(id: 7, title: "movie7", voteAverage: 10, popularity: 10, originalTitle: "", overview: "", posterPath: nil, releaseDate: "", genreIds: [1]),
                          Movie(id: 8, title: "movie8", voteAverage: 10, popularity: 10, originalTitle: "", overview: "", posterPath: nil, releaseDate: "", genreIds: [1]),
                          Movie(id: 9, title: "movie9", voteAverage: 10, popularity: 10, originalTitle: "", overview: "", posterPath: nil, releaseDate: "", genreIds: [1]),
                          Movie(id: 10, title: "movie10", voteAverage: 10, popularity: 10, originalTitle: "", overview: "", posterPath: nil, releaseDate: "", genreIds: [1])]
            callback(MovieList(results: movies, page: 1, totalResults: 1, totalPages: 1), nil, false)
        }
    }
    
    func getSearchMovies(text: String, callback: @escaping (MovieList?, String?, Bool) -> Void) {
        if showSearchError {
            callback(nil, "error", clearData)
        } else {
            let movies = [Movie(id: 1, title: "movie1", voteAverage: 10, popularity: 10, originalTitle: "", overview: "", posterPath: nil, releaseDate: "", genreIds: [1]),
                          Movie(id: 2, title: "movie2", voteAverage: 10, popularity: 10, originalTitle: "", overview: "", posterPath: nil, releaseDate: "", genreIds: [1]),
                          Movie(id: 3, title: "movie3", voteAverage: 10, popularity: 10, originalTitle: "", overview: "", posterPath: nil, releaseDate: "", genreIds: [1]),
                          Movie(id: 4, title: "movie4", voteAverage: 10, popularity: 10, originalTitle: "", overview: "", posterPath: nil, releaseDate: "", genreIds: [1])]
            callback(MovieList(results: movies, page: 1, totalResults: 1, totalPages: 1), nil, false)
        }
    }
}
