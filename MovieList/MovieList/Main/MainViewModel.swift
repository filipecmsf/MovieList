//
//  MainViewModel.swift
//  MovieList
//
//  Created by Filipe Faria on 02/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation

class MainViewModel {
    
    // MARK: - properties
    var viewEntity: MainViewEntity? {
        didSet {
            reloadTableView?()
        }
    }
    
    var interactor: MainInteractor
    var reloadTableView: (() -> Void)?
    
    // MARK: - setup methods
    init() {
        interactor = MainInteractor()
        implementInteractor()
        interactor.getGenres()
    }
    
    // MARK: - private methods
    private func implementInteractor() {
        interactor.updateList = { [weak self] mainViewEntity in
            self?.viewEntity = mainViewEntity
        }
        
        interactor.genresLoaded = { [weak self] in
            self?.interactor.getMovies()
        }
    }
    
    // MARK: - public methods
    func getMovie(index: Int) -> MainMovieViewEntity? {
        if let movie = viewEntity?.movieList[index] {
            return movie
        }
        
        return nil
    }
    
    func getListCount() -> Int {
        return viewEntity?.movieList.count ?? 0
    }
    
    func getHighlightList() -> [MainMovieViewEntity] {
        var highlightList: [MainMovieViewEntity] = []
        
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
}
