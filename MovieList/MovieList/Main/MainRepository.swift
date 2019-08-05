//
//  MainRepository.swift
//  MovieList
//
//  Created by Filipe Faria on 04/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation

protocol MainRepositoryProtocol {
    func getGenres()
    func getMovies()
}

protocol MainRepositoryResponse {
    func showError(msg: String)
    func genders(genders: GenreList)
    func movies(movies: MovieList)
    func clearData()
}

class MainRepository: MainRepositoryProtocol {
    
    private var page: Int
    private var totalPages: Int
    var delegate: MainRepositoryResponse?
    
    // MARK: - setup methods
    init() {
        page = 1
        totalPages = 100
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
            self.delegate?.showError(msg: NSLocalizedString("error.unknown_error", comment: ""))
            return
        }
        
        switch statusCode {
        case .unprocessableEntity:
            self.retry()
        case .badRequest:
            self.delegate?.showError(msg: NSLocalizedString("error.no_internet", comment: ""))
            
        default:
            self.delegate?.showError(msg: NSLocalizedString("error.unknown_error", comment: ""))
        }
    }
    
    private func retry() {
        page = 1
        getGenres()
    }
    
    func getGenres() {
        
        guard let baseUrl = Bundle.getValueFromInfo(key: .baseUrl),
            let genreUrl = Bundle.getValueFromInfo(key: .genreUrl),
            let queryItems = createQueryItems(withPage: false) else {
                self.delegate?.showError(msg: NSLocalizedString("error.unknown_error", comment: ""))
                return
        }
        
        let url = "\(baseUrl)\(genreUrl)"
        
        let request = Request(endPoint: url,
                              method: .get,
                              queryItems: queryItems,
                              header: nil)
        
        MovieApi.shared.request(request: request) { (data, error) in
            if error == nil, let content = data {
                do {
                    let genreListObj = try JSONDecoder().decode(GenreList.self, from: content)
                    self.delegate?.genders(genders: genreListObj)
                } catch let error {
                    print(error)
                    self.delegate?.showError(msg: NSLocalizedString("error.unknown_error", comment: ""))
                }
            } else {
                self.handleError(error: error)
            }
        }
    }
    
    func getMovies() {
        
        if page >= totalPages {
            return
        }
        
        guard let baseUrl = Bundle.getValueFromInfo(key: .baseUrl),
            let movieUrl = Bundle.getValueFromInfo(key: .movieUrl),
            let queryItems = createQueryItems(withPage: true) else {
                self.delegate?.showError(msg: NSLocalizedString("error.unknown_error", comment: ""))
                return
        }
        
        let url = "\(baseUrl)\(movieUrl)"
        
        let request = Request(endPoint: url,
                              method: .get,
                              queryItems: queryItems,
                              header: nil)
        
        MovieApi.shared.request(request: request) { (data, error) in
            if error == nil, let content = data {
                do {
                    let movieListObj = try JSONDecoder().decode(MovieList.self, from: content)
                    self.totalPages = movieListObj.totalPages
                    self.page += 1
                    self.delegate?.movies(movies: movieListObj)
                } catch let error {
                    print(error)
                    self.delegate?.showError(msg: NSLocalizedString("error.unknown_error", comment: ""))
                }
            } else {
                
                self.handleError(error: error)
            }
        }
    }
}
