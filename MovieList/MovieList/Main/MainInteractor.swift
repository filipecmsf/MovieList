//
//  MainInteractor.swift
//  MovieList
//
//  Created by Filipe Faria on 02/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation

class MainInteractor {
    var page: Int
    var movieList: [Movie] = []
    var highlightList: [Int] = []
    
    var updateList: ((MainViewEntity) -> Void)?
    var showError: ((String) -> Void)?
    
    init() {
        page = 1
    }
    
    func getMovies() {
        
        guard let url = Bundle.getValueFromInfo(key: .baseUrl) else {
            // TODO: show error
            return
        }
        
        let request = Request(endPoint: url,
                              method: .get,
                              queryItems: ["api_key":"1f54bd990f1cdfb230adb312546d765d", "page": String(page)],
                              header: nil)
        
        MovieApi().requestMovieList(request: request) { (data, error) in
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
}
