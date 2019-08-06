//
//  SearchInteractor.swift
//  MovieList
//
//  Created by Filipe Faria on 05/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation

class SearchInteractor {
    
    var mainRepository: MainRepository
    private var movieList: [Movie] = []
    private var genreList: [Genre] = []
    private var movieViewEntityList: [SearchMovieViewEntity] = []
    
    var updateList: ((SearchViewEntity) -> Void)?
    var genresLoaded: (() -> Void)?
    var showError: ((String) -> Void)?
    
    init(repository: MainRepository) {
        mainRepository = repository
    }
    
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
    
    private func getGenresNames(genres: [Int]) -> [String] {
        var genreNameList: [String] = []
        
        for id in genres {
            
            guard let genre = genreList.first(where: { $0.id == id }) else {
                break
            }
            
            genreNameList.append(genre.name)
        }
        
        return genreNameList
    }
    
    private func showError(msg: String) {
        self.showError?(msg)
    }
    
    private func genders(genders: GenreList) {
        self.genreList = genders.genres
        self.genresLoaded?()
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
        
        if genreList.isEmpty {
            getGenres()
        } else {
            getMovies(text: text)
        }
    }
    
    func getMovies(text: String) {
        mainRepository.resetSearchData()
        mainRepository.getSearchMovies(text: text) { moviesList, error, clearData in
            if clearData {
                self.clearData()
                return
            } else if let msg = error, !msg.isEmpty {
                self.showError(msg: msg)
            } else if let movies = moviesList {
                self.movies(movies: movies)
            }
        }
    }
    
    func getGenres() {
        mainRepository.getGenres { (genresList, error) in
            if let msg = error, !msg.isEmpty {
                self.showError(msg: msg)
            } else if let genres = genresList {
                self.genders(genders: genres)
            }
        }
    }
    
    func getMovieBy(id: Int) -> Movie? {
        return movieList.first { $0.id == id }
    }
}
