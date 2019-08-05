//
//  MainInteractor.swift
//  MovieList
//
//  Created by Filipe Faria on 02/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation

class MainInteractor {
    
    // MARK: - properties
    private var movieList: [Movie] = []
    private var movieViewEntityList: [MainMovieViewEntity] = []
    private var genreList: [Genre] = []
    private var highlightList: [Int] = []
    private let highlightLimit = 10
    
    var updateList: ((MainViewEntity) -> Void)?
    var genresLoaded: (() -> Void)?
    var showError: ((String) -> Void)?
    
    var mainRepository: MainRepository
    
    // MARK: - setup methods
    init(repository: MainRepository) {
        mainRepository = repository
        mainRepository.delegate = self
    }
    
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
    
    private func getGenresNames(genres: [Int]) -> [String] {
        var genreNameList: [String] = []
        
        for id in genres {
            
            guard let genre = genreList.first(where: {$0.id == id}) else {
                break
            }
            
            genreNameList.append(genre.name)
        }
        
        return genreNameList
    }
    
    private func createHighlightList() -> [Int] {
        var highlightList: [Int] = []
        
        repeat {
            let position = Int.random(in: 0 ..< movieViewEntityList.count)
            if !highlightList.contains(position) {
                highlightList.append(position)
            }
        } while highlightList.count < highlightLimit
        
        return highlightList.sorted(by: { $0 < $1 })
    }
    
    // MARK: - public methods
    func getMovieBy(id: Int) -> Movie? {
        return movieList.first(where: { $0.id == id })
    }
    
    func getMovies() {
        mainRepository.getMovies()
    }
    
    func getGenres() {
        mainRepository.getGenres()
    }
}

extension MainInteractor: MainRepositoryResponse {
    func showError(msg: String) {
        self.showError?(msg)
    }
    
    func genders(genders: GenreList) {
        self.genreList = genders.genres
        self.genresLoaded?()
    }
    
    func movies(movies: MovieList) {
        self.updateMovieList(movieListObj: movies)
    }
    
    func clearData() {
        movieViewEntityList = []
        movieList = []
        highlightList = []
        genreList = []
    }
}
