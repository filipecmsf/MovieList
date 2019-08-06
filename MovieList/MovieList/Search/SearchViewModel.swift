//
//  SearchViewModel.swift
//  MovieList
//
//  Created by Filipe Faria on 05/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation

class SearchViewModel {
    
    // MARK: - properties
    internal var viewEntity: SearchViewEntity? {
        didSet {
            reloadTableView?()
        }
    }

    private var text: String = ""
    
    var interactor: SearchInteractor
    var reloadTableView: (() -> Void)?
    var showError: ((String) -> Void)?
    
    init(interactor: SearchInteractor) {
        self.interactor = interactor
        implementInteractor()
    }
    
    // MARK: - private methods
    private func implementInteractor() {
        interactor.updateList = { [weak self] mainViewEntity in
            self?.viewEntity = mainViewEntity
        }
        
        interactor.genresLoaded = { [weak self] in
            if let text = self?.text {
                self?.getMovies(text: text)
            }
        }
        
        interactor.showError = {[weak self] errorMsg in
            self?.showError?(errorMsg)
        }
    }
    
    // MARK: - public methods
    func getSearchText() -> String {
        return text
    }
    
    func getListCount() -> Int {
        return viewEntity?.movieList.count ?? 0
    }
    
    func getMoreMovies() {
        interactor.getMovies(text: text)
    }
    
    func getMovies(text: String) {
        self.text = text
        interactor.searchMovie(text: text)
    }
    
    func getMovieBy(index: Int) -> SearchMovieViewEntity? {
        if let movie = viewEntity?.movieList[index] {
            return movie
        }
        
        return nil
    }
    
    func getDetailViewEntity(id: Int) -> DetailViewEntity? {
        guard let movie = interactor.getMovieBy(id: id),
            let genderList = (viewEntity?.movieList.first { $0.id == id })?.genreList else {
                return nil
        }
        
        let detailViewEntity = DetailViewEntity(title: movie.title, posterPath: movie.posterPath, genresList: genderList, releaseDate: movie.releaseDate.formatDate(), overview: movie.overview, voteAverage: movie.voteAverage)
        
        return detailViewEntity
    }
}
