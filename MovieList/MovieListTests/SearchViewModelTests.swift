//
//  SearchViewModelTests.swift
//  MovieListTests
//
//  Created by Filipe Faria on 06/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

@testable import MovieList
import XCTest

class SearchViewModelTests: XCTestCase {
    
    var viewModel: SearchViewModel!
    var interactor: SearchInteractor!
    var repositoryMock: NextMovieRepositoryMock!

    override func setUp() {
        super.setUp()
        repositoryMock = NextMovieRepositoryMock()
        interactor = SearchInteractor(repository: repositoryMock)
    }
    
    func testGetMoviesWithSuccess() {
        viewModel = SearchViewModel(interactor: interactor)
        
        let exp = expectation(description: "viewEntity not to be nil")
        
        viewModel.reloadTableView = {[weak self] in
            XCTAssertNotNil(self?.viewModel.viewEntity)
            exp.fulfill()
        }
        
        viewModel.getMovies(text: "the lion king")
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testGetMoviesWithError() {
        repositoryMock.showSearchError = true
        repositoryMock.showGenreError = false
        viewModel = SearchViewModel(interactor: interactor)
        viewModel.getMovies(text: "the lion king")
        
        let exp = expectation(description: "show error after movies service retorn error")
        
        viewModel.showError = { msg in
            XCTAssertNotNil(msg)
            exp.fulfill()
        }
        
        viewModel.getMovies(text: "the lion king")
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testGetGenresWithError() {
        repositoryMock.showMovieError = false
        repositoryMock.showGenreError = true
        viewModel = SearchViewModel(interactor: interactor)
        
        let exp = expectation(description: "show error after genres service return error")
        
        viewModel.showError = { msg in
            XCTAssertNotNil(msg)
            exp.fulfill()
        }
        
        viewModel.getMovies(text: "the lion king")
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testGetMovieByIndexWithSuccess() {
        repositoryMock.showMovieError = false
        repositoryMock.showGenreError = false
        viewModel = SearchViewModel(interactor: interactor)
        viewModel.getMovies(text: "the lion king")
        
        let movie = viewModel.getMovieBy(index: 0)
        
        XCTAssertNotNil(movie)
        XCTAssertEqual(movie?.id, 1)
    }
    
    func testGetMovieByIndexWithError() {
        repositoryMock.showMovieError = false
        repositoryMock.showGenreError = true
        viewModel = SearchViewModel(interactor: interactor)
        
        let movie = viewModel.getMovieBy(index: 0)
        
        XCTAssertNil(movie)
    }
    
    func testGetDetailViewEntityWithSuccess() {
        repositoryMock.showMovieError = false
        repositoryMock.showGenreError = false
        viewModel = SearchViewModel(interactor: interactor)
        viewModel.getMovies(text: "the lion king")
        
        let detailViewEntity = viewModel.getDetailViewEntity(id: 3)
        XCTAssertNotNil(detailViewEntity)
        XCTAssertEqual(detailViewEntity?.title, "movie3")
    }
    
    func testGetDetailViewEntityWithError() {
        repositoryMock.showMovieError = false
        repositoryMock.showGenreError = false
        viewModel = SearchViewModel(interactor: interactor)
        
        let detailViewEntity = viewModel.getDetailViewEntity(id: 11)
        XCTAssertNil(detailViewEntity)
    }
    
    func testGetMovieCount() {
        repositoryMock.showMovieError = false
        repositoryMock.showGenreError = false
        viewModel = SearchViewModel(interactor: interactor)
        viewModel.getMovies(text: "the lion king")
        
        XCTAssertEqual(viewModel.getListCount(), 4)
    }
}
