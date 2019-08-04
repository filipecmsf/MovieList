//
//  DetailViewModel.swift
//  
//
//  Created by Filipe Faria on 03/08/19.
//

import Foundation

class DetailViewModel {
    private let detailViewEntity: DetailViewEntity
    
    init(detailViewEntity: DetailViewEntity) {
        self.detailViewEntity = detailViewEntity
    }
    
    func getPosterPath() -> String? {
        return detailViewEntity.posterPath
    }
    
    func getTitle() -> String {
        return detailViewEntity.title
    }
    
    func getVoteAverage() -> String {
        return String(detailViewEntity.voteAverage)
    }
    
    func getGenders() -> String {
        return detailViewEntity.genresList.joined(separator: ", ")
    }
    
    func getReleaseDate() -> String {
        return detailViewEntity.releaseDate
    }
    
    func getOverview() -> String {
        return detailViewEntity.overview
    }
}
