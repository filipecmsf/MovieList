//
//  MainViewModel.swift
//  MovieList
//
//  Created by Filipe Faria on 02/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation

class MainViewModel {
    var viewEntity: MainViewEntity? {
        didSet {
            reloadTableView?()
        }
    }
    
    var interactor: MainInteractor
    
    var reloadTableView: (() -> Void)?
    
    init() {
        interactor = MainInteractor()
        implementInteractor()
        interactor.getMovies()
    }
    
    private func implementInteractor() {
        interactor.updateList = { [weak self] mainViewEntity in
            self?.viewEntity = mainViewEntity
        }
    }
    
    func getListCount() -> Int {
        return viewEntity?.movieList.count ?? 0
    }
    
    func getHighlightList() -> [Movie] {
        var highlightList: [Movie] = []
        
        guard let list = viewEntity?.highlightList else {
            return []
        }
        
        for position in list {
            if let movie = getMovie(index: position) {
                highlightList.append(movie)
            }
        }
        
        return highlightList
    }
    
    func getMovieName(index: Int) -> String {
        if let movie = getMovie(index: index) {
            return movie.title
        }
        
        return "--"
    }
    
    func getMovieReleaseDate(index: Int) -> String {
        if let movie = getMovie(index: index) {
            return movie.releaseDate
        }
        
        return "--"
    }
    
    func getImagePath(index: Int) -> String? {
        if let movie = getMovie(index: index) {
            return movie.posterPath
        }
        
        return nil
    }
    
    private func getMovie(index: Int) -> Movie? {
        if let movie = viewEntity?.movieList[index] {
            return movie
        }
        
        return nil
    }
}
