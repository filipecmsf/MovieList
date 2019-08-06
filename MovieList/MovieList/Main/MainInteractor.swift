//
//  MainInteractor.swift
//  MovieList
//
//  Created by Filipe Faria on 02/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation

class MainInteractor: BaseInteractor {
    
    // MARK: - properties
    private var movieViewEntityList: [MainMovieViewEntity] = []
    private var highlightList: [Int] = []
    private let highlightLimit = 10
    
    var updateList: ((MainViewEntity) -> Void)?
    
    // MARK: - private methods
    private func updateMovieList(movieListObj: MovieList) {
        movieList.append(contentsOf: movieListObj.results)
        movieViewEntityList.append(contentsOf: createMainMovieViewEntity(movieList: movieListObj.results))
        
        if highlightList.isEmpty {
            highlightList = createHighlightList()
        }
        
        updateList?(MainViewEntity(movieList: movieViewEntityList, highlightList: highlightList))
    }
    
    private func createMainMovieViewEntity(movieList: [Movie]) -> [MainMovieViewEntity] {
        var mainMovieViewEntityList: [MainMovieViewEntity] = []
        
        for movie in movieList {
            let genres = getGenresNames(genres: movie.genreIds)
            
            let mainMovieViewEntity = MainMovieViewEntity(id: movie.id, title: movie.title, releaseDate: movie.releaseDate.formatDate(), posterPath: movie.posterPath, genreList: genres)
            
            mainMovieViewEntityList.append(mainMovieViewEntity)
        }
        
        return mainMovieViewEntityList
    }
    
    private func createHighlightList() -> [Int] {
        var highlightList: [Int] = []
        
        repeat {
            let position = Int.random(in: 0 ..< movieViewEntityList.count)
            if !highlightList.contains(position) {
                highlightList.append(position)
            }
        } while highlightList.count < highlightLimit
        
        return highlightList.sorted { $0 < $1 }
    }
    
    private func showError(msg: String) {
        self.showError?(msg)
    }
    
    private func movies(movies: MovieList) {
        self.updateMovieList(movieListObj: movies)
    }
    
    private func clearData() {
        movieViewEntityList = []
        movieList = []
        highlightList = []
        genreList = []
        getGenres()
    }
    
    // MARK: - public methods
    func getMovieBy(id: Int) -> Movie? {
        return movieList.first { $0.id == id }
    }
    
    func getMovies() {
        mainRepository.getMovies { moviesList, error, clearData in
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
}
