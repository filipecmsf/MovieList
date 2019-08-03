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
    var page: Int
    var movieList: [Movie] = []
    var genreList: [Genre] = []
    var highlightList: [Int] = []
    
    var updateList: ((MainViewEntity) -> Void)?
    var genresLoaded: (() -> Void)?
    var showError: ((String) -> Void)?
    
    // MARK: - setup methods
    init() {
        page = 1
    }
    
    // MARK: - private methods
    // TODO: implement method return
    private func createQueryItems() -> [String: String] {
        return [:]
    }
    
    private func updateMovieList(movieListObj: MovieList) {
        
        movieList.append(contentsOf: movieListObj.results)
        
        if highlightList.isEmpty {
            highlightList = createHighlightList()
        }
        
        updateList?(MainViewEntity(movieList: movieList, highlightList: highlightList))
    }
    
    private func createHighlightList() -> [Int] {
        var highlightList: [Int] = []
        
        repeat {
            let position = Int.random(in: 0 ..< movieList.count)
            if !highlightList.contains(position) {
                highlightList.append(position)
            }
        } while highlightList.count < 5
        
        return highlightList.sorted(by: { $0 < $1 })
    }
    
    // MARK: - public methods
    func getMovies() {
        
        guard let baseUrl = Bundle.getValueFromInfo(key: .baseUrl),
            let movieUrl = Bundle.getValueFromInfo(key: .movieUrl),
            let apiKey = Bundle.getValueFromInfo(key: .apiKey) else {
                // TODO: show error
                return
        }
        
        let url = "\(baseUrl)\(movieUrl)"
        
        let request = Request(endPoint: url,
                              method: .get,
                              queryItems: ["api_key":apiKey, "page": String(page)],
                              header: nil)
        
        MovieApi().request(request: request) { (data, error) in
            if error == nil, let content = data {
                do {
                    let movieListObj = try JSONDecoder().decode(MovieList.self, from: content)
                    self.page += 1
                    self.updateMovieList(movieListObj: movieListObj)
                } catch let error {
                    // TODO: show error
                }
            } else {
                // TODO: show error
            }
        }
    }
    
    func getGenres() {
        
        guard let baseUrl = Bundle.getValueFromInfo(key: .baseUrl),
            let genreUrl = Bundle.getValueFromInfo(key: .genreUrl),
            let apiKey = Bundle.getValueFromInfo(key: .apiKey) else {
                // TODO: show error
                return
        }

        let url = "\(baseUrl)\(genreUrl)"

        let request = Request(endPoint: url,
                              method: .get,
                              queryItems: ["api_key":apiKey],
                              header: nil)

        MovieApi().request(request: request) { (data, error) in
            if error == nil, let content = data {
                do {
                    let genreListObj = try JSONDecoder().decode(GenreList.self, from: content)
                    self.genreList = genreListObj.genres
                    self.genresLoaded?()
                } catch let error {
                    // TODO: show error
                }
            } else {
                // TODO: show error
            }
        }
    }
}
