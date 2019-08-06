//
//  SearchRepository.swift
//  MovieList
//
//  Created by Filipe Faria on 05/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation

protocol SearchRepositoryProtocol {
    func getMovies(text: String, callback: @escaping (_ movies: MovieList?, _ error: String?, _ clearData: Bool) -> Void)
}

class SearchRepository: SearchRepositoryProtocol {
    
    private var page: Int
    private var totalPages: Int
    
    // MARK: - setup methods
    init() {
        page = 1
        totalPages = 100
    }
    
    private func createQueryItems() -> [String: String]? {
        guard let apiKey = Bundle.getValueFromInfo(key: .apiKey) else {
            return nil
        }
        
        let queryItems: [String: String] = ["api_key": apiKey]
        
        return queryItems
    }
    
    private func addMovieListItems(text: String, queryItems: inout [String: String]) {
        queryItems["page"] = String(page)
        queryItems["query"] = text
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
    
    private func retry() {
        page = 1
    }
    
    func getMovies(text: String, callback: @escaping (MovieList?, String?, Bool) -> Void) {
        if page >= totalPages {
            return
        }
        
        guard let baseUrl = Bundle.getValueFromInfo(key: .baseUrl),
            let searchUrl = Bundle.getValueFromInfo(key: .searchUrl),
            var queryItems = createQueryItems() else {
                callback( nil, NSLocalizedString("error.unknown_error", comment: ""), false)
                return
        }
        
        addMovieListItems(text: text, queryItems: &queryItems)
        
        let url = "\(baseUrl)\(searchUrl)"
        
        let request = Request(endPoint: url,
                              method: .get,
                              queryItems: queryItems,
                              header: nil)
        
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
    
    func getGenres(callback: @escaping (_ genres: GenreList?, _ error: String?) -> Void) {
        
        guard let baseUrl = Bundle.getValueFromInfo(key: .baseUrl),
            let genreUrl = Bundle.getValueFromInfo(key: .genreUrl),
            let queryItems = createQueryItems() else {
                callback(nil, NSLocalizedString("error.unknown_error", comment: ""))
                return
        }
        
        let url = "\(baseUrl)\(genreUrl)"
        
        let request = Request(endPoint: url,
                              method: .get,
                              queryItems: queryItems,
                              header: nil)
        
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
}
