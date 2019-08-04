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
    private var page: Int
    private var totalPages: Int
    private var movieList: [Movie] = []
    private var movieViewEntityList: [MainMovieViewEntity] = []
    private var genreList: [Genre] = []
    private var highlightList: [Int] = []
    private let highlightLimit = 10
    
    var updateList: ((MainViewEntity) -> Void)?
    var genresLoaded: (() -> Void)?
    var showError: ((String) -> Void)?
    
    // MARK: - setup methods
    init() {
        page = 1
        totalPages = 100
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
            
            let mainMovieViewEntity = MainMovieViewEntity(id: movie.id, title: movie.title, releaseDate: movie.releaseDate, posterPath: movie.posterPath, genreList: genres)
            
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
    
    private func retry() {
        page = 1
        movieViewEntityList = []
        movieList = []
        highlightList = []
        genreList = []
        getGenres()
    }
    
    private func createQueryItems(withPage: Bool) -> [String: String]? {
        guard let apiKey = Bundle.getValueFromInfo(key: .apiKey) else {
            return nil
        }
        
        var queryItems: [String: String] = ["api_key": apiKey]
        
        if withPage {
            queryItems["page"] = String(page)
        }
        
        return queryItems
    }
    
    private func handleError(error: ServerError?) {
        guard let statusCode = error?.statusCode else {
            self.showError?(NSLocalizedString("error.unknown_error", comment: ""))
            return
        }
        
        switch statusCode {
        case .unprocessableEntity:
            self.retry()
        case .badRequest:
            self.showError?(NSLocalizedString("error.no_internet", comment: ""))
            
        default:
            self.showError?(NSLocalizedString("error.unknown_error", comment: ""))
        }
    }
    
    // MARK: - public methods
    func getMovieBy(id: Int) -> Movie? {
        return movieList.first(where: { $0.id == id })
    }
    
    func getMovies() {
        
        if page >= totalPages {
            return
        }
        
        guard let baseUrl = Bundle.getValueFromInfo(key: .baseUrl),
            let movieUrl = Bundle.getValueFromInfo(key: .movieUrl),
            let queryItems = createQueryItems(withPage: true) else {
                self.showError?(NSLocalizedString("error.unknown_error", comment: ""))
                return
        }
        
        let url = "\(baseUrl)\(movieUrl)"
        
        let request = Request(endPoint: url,
                              method: .get,
                              queryItems: queryItems,
                              header: nil)
        
        MovieApi().request(request: request) { (data, error) in
            if error == nil, let content = data {
                do {
                    let movieListObj = try JSONDecoder().decode(MovieList.self, from: content)
                    self.totalPages = movieListObj.totalPages
                    self.page += 1
                    self.updateMovieList(movieListObj: movieListObj)
                } catch let error {
                    print(error)
                    self.showError?(NSLocalizedString("error.unknown_error", comment: ""))
                }
            } else {
                
                self.handleError(error: error)
            }
        }
    }
    
    func getGenres() {
        
        guard let baseUrl = Bundle.getValueFromInfo(key: .baseUrl),
            let genreUrl = Bundle.getValueFromInfo(key: .genreUrl),
            let queryItems = createQueryItems(withPage: false) else {
                self.showError?(NSLocalizedString("error.unknown_error", comment: ""))
                return
        }

        let url = "\(baseUrl)\(genreUrl)"

        let request = Request(endPoint: url,
                              method: .get,
                              queryItems: queryItems,
                              header: nil)

        MovieApi().request(request: request) { (data, error) in
            if error == nil, let content = data {
                do {
                    let genreListObj = try JSONDecoder().decode(GenreList.self, from: content)
                    self.genreList = genreListObj.genres
                    self.genresLoaded?()
                } catch let error {
                    print(error)
                    self.showError?(NSLocalizedString("error.unknown_error", comment: ""))
                }
            } else {
                self.handleError(error: error)
            }
        }
    }
}
