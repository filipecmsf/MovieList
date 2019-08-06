//
//  BaseInteractor.swift
//  MovieList
//
//  Created by Filipe Faria on 05/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation

class BaseInteractor {
    
    var movieList: [Movie] = []
    var genreList: [Genre] = []
    
    var genresLoaded: (() -> Void)?
    var showError: ((String) -> Void)?
    
    var mainRepository: NextMovieRepositoryProtocol
    
    init(repository: NextMovieRepositoryProtocol) {
        mainRepository = repository
    }
    
    private func genders(genders: GenreList) {
        self.genreList = genders.genres
        self.genresLoaded?()
    }
    
    internal func getGenresNames(genres: [Int]) -> [String] {
        var genreNameList: [String] = []
        
        for id in genres {
            
            guard let genre = genreList.first(where: { $0.id == id }) else {
                break
            }
            
            genreNameList.append(genre.name)
        }
        
        return genreNameList
    }
    
    func getGenres() {
        mainRepository.getGenres { genresList, error in
            if let msg = error, !msg.isEmpty {
                self.showError?(msg)
            } else if let genres = genresList {
                self.genders(genders: genres)
            }
        }
    }
}
