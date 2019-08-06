//
//  SearchInteractor.swift
//  MovieList
//
//  Created by Filipe Faria on 05/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation

class SearchInteractor: BaseInteractor {
    
    // MARK: - properties
    private var movieViewEntityList: [SearchMovieViewEntity] = []
    var updateList: ((SearchViewEntity) -> Void)?
    
    // MARK: - private methods
    private func updateMovieList(movieListObj: MovieList) {
        movieList.append(contentsOf: movieListObj.results)
        movieViewEntityList.append(contentsOf: createMainMovieViewEntity(movieList: movieListObj.results))

        updateList?(SearchViewEntity(movieList: movieViewEntityList))
    }
    
    private func createMainMovieViewEntity(movieList: [Movie]) -> [SearchMovieViewEntity] {
        var mainMovieViewEntityList: [SearchMovieViewEntity] = []
        
        for movie in movieList {
            let genres = getGenresNames(genres: movie.genreIds)
            
            let mainMovieViewEntity = SearchMovieViewEntity(id: movie.id, title: movie.title, releaseDate: movie.releaseDate.formatDate(), posterPath: movie.posterPath, genreList: genres)
            
            mainMovieViewEntityList.append(mainMovieViewEntity)
        }
        
        return mainMovieViewEntityList
    }
    
    private func movies(movies: MovieList) {
        self.updateMovieList(movieListObj: movies)
    }
    
    private func clearData() {
        movieViewEntityList = []
        movieList = []
        genreList = []
        getGenres()
    }
    
    // MARK: - public methods
    func searchMovie(text: String) {
        
        movieList = []
        movieViewEntityList = []
        mainRepository.resetSearchData()
        
        if genreList.isEmpty {
            getGenres()
        } else {
            getMovies(text: text)
        }
    }
    
    func getMovies(text: String) {
        mainRepository.getSearchMovies(text: text) { moviesList, error, clearData in
            if clearData {
                self.clearData()
                return
            } else if let msg = error, !msg.isEmpty {
                self.showError?(msg)
            } else if let movies = moviesList {
                self.movies(movies: movies)
            }
        }
    }
    
    func getMovieBy(id: Int) -> Movie? {
        return movieList.first { $0.id == id }
    }
}
