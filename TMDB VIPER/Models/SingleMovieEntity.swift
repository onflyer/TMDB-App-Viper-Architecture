//
//  MovieEntity.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 12. 1. 2025..
//

import SwiftData
import SwiftUI

@Model
class SingleMovieEntity {
    var adult: Bool?
    var backdropPath: String?
    var id: Int
    var originalTitle: String?
    var overview: String?
    var popularity: Double?
    var posterPath: String?
    var releaseDate: String?
    var title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    var dateAdded: Date
    
    init (from model: SingleMovie) {
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
        self.dateAdded = .now
        
    }
    
    func toModel() -> SingleMovie {
        SingleMovie(adult: adult, backdropPath: backdropPath, budget: nil, genres: nil, homepage: nil, id: id, imdbID: nil, originalLanguage: nil, originalTitle: originalTitle, overview: overview, popularity: popularity, posterPath: posterPath, releaseDate: releaseDate, revenue: nil, runtime: nil, status: nil, tagline: nil, title: title, video: nil, voteAverage: voteAverage, voteCount: voteCount, videos: nil, credits: nil)
    }
    
}
