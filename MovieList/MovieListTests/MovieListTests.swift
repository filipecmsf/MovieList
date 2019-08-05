//
//  MovieListTests.swift
//  MovieListTests
//
//  Created by Filipe Faria on 01/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import XCTest
@testable import MovieList

class MainViewModelTests: XCTestCase {

    var viewModel: MainViewModel!
    
    override func setUp() {
        viewModel = MainViewModel()
    }

    func testExample() {
        viewModel = MainViewModel()
//        XCTAssertNotNil(viewModel.viewEntity)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
