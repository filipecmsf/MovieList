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
    internal var viewEntity: MainViewEntity? {
        didSet {
            reloadTableView?()
        }
    }
    
    private var interactor: MainInteractor
    private var loadingMovies: Bool = false
    
    var reloadTableView: (() -> Void)?
    var showError: ((String) -> Void)?
    
    // MARK: - setup methods
    init(interactor: MainInteractor = MainInteractor(repository: MainRepository())) {
        self.interactor = interactor
        implementInteractor()
        self.interactor.getGenres()
    }
    
    // MARK: - private methods
    private func implementInteractor() {
        interactor.updateList = { [weak self] mainViewEntity in
            self?.viewEntity = mainViewEntity
            self?.loadingMovies = false
        }
        
        interactor.genresLoaded = { [weak self] in
            self?.getMovies()
        }
        
        interactor.showError = {[weak self] errorMsg in
            self?.showError?(errorMsg)
            self?.loadingMovies = false
        }
    }
    
    // MARK: - public methods
    func retryLoadData() {
        interactor.getGenres()
    }
    
    func getMovies() {
        if !loadingMovies {
            loadingMovies = true
            interactor.getMovies()
        }
    }
    
    func getMovieBy(index: Int) -> MainMovieViewEntity? {
        if let movie = viewEntity?.movieList[index] {
            return movie
        }
        
        return nil
    }
    
    func getDetailViewEntity(id: Int) -> DetailViewEntity? {
        guard let movie = interactor.getMovieBy(id: id),
        let genderList = viewEntity?.movieList.first(where: {$0.id == id})?.genreList else {
            return nil
        }
        
        let detailViewEntity = DetailViewEntity(title: movie.title, posterPath: movie.posterPath, genresList: genderList, releaseDate: movie.releaseDate, overview: movie.overview, voteAverage: movie.voteAverage)
        
        return detailViewEntity
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
            if let movie = getMovieBy(index: position) {
                highlightList.append(movie)
            }
        }
        
        return highlightList
    }
}
