//
//  MovieEntity.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 12. 1. 2025..
//

import SwiftData

@Model
class MovieEntity {
    var adult: Bool?
    var backdropPath: String?
    var id: Int
    var originalTitle: String?
    var overview: String?
    var popularity: Double?
    var posterPath: String
    var releaseDate: String?
    var title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    
    init (from model: Movie) {
        self.adult = model.adult
        self.backdropPath = model.backdropPath
        self.id = model.id
        self.originalTitle = model.originalTitle
        self.overview = model.overview
        self.popularity = model.popularity
        self.posterPath = model.posterPath
        self.releaseDate = model.releaseDate
        self.title = model.title
        self.video = model.video
        self.voteAverage = model.voteAverage
        self.voteCount = model.voteCount
        
    }
    
    func toModel() -> Movie {
        Movie(
            adult: adult,
            backdropPath: backdropPath,
            genreIDS: nil,
            id: id,
            originalTitle: originalTitle,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            releaseDate: releaseDate,
            title: title,
            video: video,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }
    
}
