//
//  ModelsTests.swift
//  TMDB VIPERTests
//
//  Created by Aleksandar Milidrag on 2. 2. 2025..
//

import Testing
import SwiftUI
@testable import TMDB_VIPER

struct ModelsTests {
    
    @Test func testMovieInitialization() {
        let movie = Movie(
            adult: false,
            backdropPath: "/backdrop.jpg",
            genreIDS: [28, 12],
            id: 12345,
            originalTitle: "Original Title",
            overview: "This is a sample overview.",
            popularity: 8.5,
            posterPath: "/poster.jpg",
            releaseDate: "2024-02-02",
            title: "Movie Title",
            video: false,
            voteAverage: 7.8,
            voteCount: 2000
        )

        #expect(movie.id == 12345)
        #expect(movie.title == "Movie Title")
        #expect(movie.posterPath == "/poster.jpg")
        #expect(movie.genreIDS != nil)
    }
    
    @Test func testMoviesCodableConformance() throws {
        let movie = Movie(
            adult: false,
            backdropPath: "/backdrop.jpg",
            genreIDS: [28, 12],
            id: 12345,
            originalTitle: "Original Title",
            overview: "This is a sample overview.",
            popularity: 8.5,
            posterPath: "/poster.jpg",
            releaseDate: "2024-02-02",
            title: "Movie Title",
            video: false,
            voteAverage: 7.8,
            voteCount: 2000
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(movie)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Movie.self, from: data)

        #expect(decoded.id == 12345)
        #expect(decoded.originalTitle == "Original Title")
        #expect(decoded.voteAverage == 7.8)
        #expect(decoded.adult == false)
    }
    
    
    @Test func testMovieWithNilProperties() {
        let movie = Movie(
            adult: nil,
            backdropPath: nil,
            genreIDS: nil,
            id: 55555,
            originalTitle: nil,
            overview: nil,
            popularity: nil,
            posterPath: "/poster.jpg",
            releaseDate: nil,
            title: nil,
            video: nil,
            voteAverage: nil,
            voteCount: nil
        )

        #expect(movie.adult == nil)
        #expect(movie.genreIDS == nil)
        #expect(movie.popularity == nil)
        #expect(movie.id == 55555)
        #expect(movie.posterPath == "/poster.jpg")
    }



}
