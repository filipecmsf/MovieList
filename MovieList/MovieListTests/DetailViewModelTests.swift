//
//  DetailViewModelTests.swift
//  MovieListTests
//
//  Created by Filipe Faria on 04/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import XCTest
@testable import MovieList

class DetailViewModelTests: XCTestCase {
    
    var viewModel: DetailViewModel!
    
    override func setUp() {
        let detailViewEntity = DetailViewEntity(title: "The Lion King", posterPath: "/lion.jpg", genresList: ["Animation", "Family"], releaseDate: "01/01/2019", overview: "an overview", voteAverage: 10)
        
        viewModel = DetailViewModel(detailViewEntity: detailViewEntity)
    }
    
    func testGetMovieData() {
        XCTAssertEqual(viewModel.getTitle(), "The Lion King")
        XCTAssertEqual(viewModel.getPosterPath(), "/lion.jpg")
        XCTAssertEqual(viewModel.getGenders().count, 17)
        XCTAssertEqual(viewModel.getReleaseDate(), "01/01/2019")
        XCTAssertEqual(viewModel.getOverview(), "an overview")
        XCTAssertEqual(viewModel.getVoteAverage(), String(Float(10)))
    }
}
