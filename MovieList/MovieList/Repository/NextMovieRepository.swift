//
//  NextMovieRepository.swift
//  MovieList
//
//  Created by Filipe Faria on 04/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation

protocol NextMovieRepositoryProtocol {
    func getGenres(callback: @escaping (_ genres: GenreList?, _ error: String?) -> Void)
    func getMovies(callback: @escaping (_ movies: MovieList?, _ error: String?, _ clearData: Bool) -> Void)
    func getSearchMovies(text: String, callback: @escaping (_ movies: MovieList?, _ error: String?, _ clearData: Bool) -> Void)
    func resetSearchData()
}

class NextMovieRepository: NextMovieRepositoryProtocol {
    
    private var page: Int
    private var totalPages: Int
    
    // MARK: - setup methods
    init() {
        page = 1
        totalPages = 100
    }
    
    // MARK: - private methods
    private func createQueryItems() -> [String: String]? {
        guard let apiKey = Bundle.getValueFromInfo(key: .apiKey) else {
            return nil
        }
        
        let queryItems: [String: String] = ["api_key": apiKey]
        
        return queryItems
    }
    
    private func addSearchMovieListItems(text: String, queryItems: inout [String: String]) {
        queryItems["page"] = String(page)
        queryItems["query"] = text
    }
    
    private func addMovieListItems(queryItems: inout [String: String]) {
        queryItems["page"] = String(page)
        queryItems["region"] = Locale.current.regionCode
    }
    
    private func handleError(error: ServerError?) -> String {
        guard let statusCode = error?.statusCode else {
            return NSLocalizedString("error.unknown_error", comment: "")
        }
        
        switch statusCode {
        case .badRequest:
            return NSLocalizedString("error.no_internet", comment: "")   
        default:
            return NSLocalizedString("error.unknown_error", comment: "")
        }
    }
    
    private func createGenderRequest() -> Request? {
        guard let baseUrl = Bundle.getValueFromInfo(key: .baseUrl),
            let genreUrl = Bundle.getValueFromInfo(key: .genreUrl),
            let queryItems = createQueryItems() else {
                
                return nil
        }
        
        let url = "\(baseUrl)\(genreUrl)"
        
        return Request(endPoint: url, method: .get, queryItems: queryItems, header: nil)
    }
    
    private func createMovieRequest() -> Request? {
        guard let baseUrl = Bundle.getValueFromInfo(key: .baseUrl),
            let movieUrl = Bundle.getValueFromInfo(key: .movieUrl),
            var queryItems = createQueryItems() else {
                return nil
        }
        
        addMovieListItems(queryItems: &queryItems)
        
        let url = "\(baseUrl)\(movieUrl)"
        
        return Request(endPoint: url, method: .get, queryItems: queryItems, header: nil)
    }
    
    private func createRequestSearch(text: String) -> Request? {
        guard let baseUrl = Bundle.getValueFromInfo(key: .baseUrl),
            let searchUrl = Bundle.getValueFromInfo(key: .searchUrl),
            var queryItems = createQueryItems() else {
                return nil
        }
        
        addSearchMovieListItems(text: text, queryItems: &queryItems)
        
        let url = "\(baseUrl)\(searchUrl)"
        
        return Request(endPoint: url, method: .get, queryItems: queryItems, header: nil)
    }
    
    // MARK: - public methods
    func resetSearchData() {
        page = 1
        totalPages = 100
    }
    
    func getGenres(callback: @escaping (_ genres: GenreList?, _ error: String?) -> Void) {
        
        guard let request = createGenderRequest() else {
            callback(nil, NSLocalizedString("error.unknown_error", comment: ""))
            return
        }
        
        MovieApi.shared.request(request: request) { data, error in
            if error == nil, let content = data {
                do {
                    let genreListObj = try JSONDecoder().decode(GenreList.self, from: content)
                    callback( genreListObj, nil)
                } catch let error {
                    print(error)
                    callback(nil, NSLocalizedString("error.unknown_error", comment: ""))
                }
            } else {
                callback(nil, self.handleError(error: error))
            }
        }
    }
    
    func getMovies(callback: @escaping (_ movies: MovieList?, _ error: String?, _ clearData: Bool) -> Void) {
        
        if page > totalPages {
            return
        }
        
        guard let request = createMovieRequest() else {
            callback( nil, NSLocalizedString("error.unknown_error", comment: ""), false)
            return
        }
        
        MovieApi.shared.request(request: request) { data, error in
            if error == nil, let content = data {
                do {
                    let movieListObj = try JSONDecoder().decode(MovieList.self, from: content)
                    self.totalPages = movieListObj.totalPages
                    self.page += 1
                    callback(movieListObj, nil, false)
                } catch let error {
                    print(error)
                    callback(nil, NSLocalizedString("error.unknown_error", comment: ""), false)
                }
            } else {
                
                if error?.statusCode == ErrorStatusCode.unprocessableEntity {
                    callback(nil, nil, true)
                    return
                }
                
                callback(nil, self.handleError(error: error), false)
            }
        }
    }
    
    func getSearchMovies(text: String, callback: @escaping (MovieList?, String?, Bool) -> Void) {
        if page >= totalPages {
            return
        }
        
        guard let request = createRequestSearch(text: text) else {
            callback( nil, NSLocalizedString("error.unknown_error", comment: ""), false)
            return
        }
        
        MovieApi.shared.request(request: request) { data, error in
            if error == nil, let content = data {
                do {
                    let movieListObj = try JSONDecoder().decode(MovieList.self, from: content)
                    self.totalPages = movieListObj.totalPages
                    self.page += 1
                    callback(movieListObj, nil, false)
                } catch let error {
                    print(error)
                    callback(nil, NSLocalizedString("error.unknown_error", comment: ""), false)
                }
            } else {
                
                if error?.statusCode == ErrorStatusCode.unprocessableEntity {
                    callback(nil, nil, true)
                    return
                }
                
                callback(nil, self.handleError(error: error), false)
            }
        }
    }
}
