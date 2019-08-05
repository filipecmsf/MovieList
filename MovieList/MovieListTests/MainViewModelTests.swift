//
//  MainViewModelTests.swift
//  MovieListTests
//
//  Created by Filipe Faria on 01/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import XCTest
@testable import MovieList

class MainViewModelTests: XCTestCase {

    var viewModel: MainViewModel!
    var interactor: MainInteractor!
    var repositoryMock: MainRepositoryMock!
    
    override func setUp() {
        repositoryMock = MainRepositoryMock()
        interactor = MainInteractor(repository: repositoryMock)
    }

    func testGetMoviesWithSuccess() {
        viewModel = MainViewModel(interactor: interactor)
        
        let exp = expectation(description: "viewEntity not to be nil")
        
        viewModel.reloadTableView = {[weak self] in
            XCTAssertNotNil(self?.viewModel.viewEntity)
            exp.fulfill()
        }
        
        viewModel.getMovies()
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testGetMoviesWithError() {
        repositoryMock.showMovieError = true
        repositoryMock.showGenreError = false
        viewModel = MainViewModel(interactor: interactor)
        
        let exp = expectation(description: "show error after movies service retorn error")
        
        viewModel.showError = { msg in
            XCTAssertNotNil(msg)
            exp.fulfill()
        }
        
        viewModel.getMovies()
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testGetGenresWithError() {
        repositoryMock.showMovieError = false
        repositoryMock.showGenreError = true
        viewModel = MainViewModel(interactor: interactor)
        
        let exp = expectation(description: "show error after genres service return error")
        
        viewModel.showError = { msg in
            XCTAssertNotNil(msg)
            exp.fulfill()
        }
        
        viewModel.retryLoadData()
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testGetMovieByIndexWithSuccess() {
        repositoryMock.showMovieError = false
        repositoryMock.showGenreError = false
        viewModel = MainViewModel(interactor: interactor)
        
        let movie = viewModel.getMovieBy(index: 0)
        
        XCTAssertNotNil(movie)
        XCTAssertEqual(movie?.id, 1)
    }
    
    func testGetMovieByIndexWithError() {
        repositoryMock.showMovieError = false
        repositoryMock.showGenreError = true
        viewModel = MainViewModel(interactor: interactor)
        
        let movie = viewModel.getMovieBy(index: 0)
        
        XCTAssertNil(movie)
    }
    
    func testGetDetailViewEntityWithSuccess() {
        repositoryMock.showMovieError = false
        repositoryMock.showGenreError = false
        viewModel = MainViewModel(interactor: interactor)
        
        let detailViewEntity = viewModel.getDetailViewEntity(id: 3)
        XCTAssertNotNil(detailViewEntity)
        XCTAssertEqual(detailViewEntity?.title, "movie3")
    }
    
    func testGetDetailViewEntityWithError() {
        repositoryMock.showMovieError = false
        repositoryMock.showGenreError = false
        viewModel = MainViewModel(interactor: interactor)
        
        let detailViewEntity = viewModel.getDetailViewEntity(id: 11)
        XCTAssertNil(detailViewEntity)
    }
    
    func testGetMovieCount() {
        repositoryMock.showMovieError = false
        repositoryMock.showGenreError = false
        viewModel = MainViewModel(interactor: interactor)
        
        XCTAssertEqual(viewModel.getListCount(), 10)
    }
    
    func testGetHighLightMovieListWithSuccess() {
        repositoryMock.showMovieError = false
        repositoryMock.showGenreError = false
        viewModel = MainViewModel(interactor: interactor)
        
        let movies = viewModel.getHighlightList()
        XCTAssertEqual(movies.count, 10)
    }
    
    func testGetHighLightMovieListWithServerError() {
        repositoryMock.showMovieError = true
        repositoryMock.showGenreError = false
        viewModel = MainViewModel(interactor: interactor)
        
        let movies = viewModel.getHighlightList()
        XCTAssertEqual(movies.count, 0)
    }
}
