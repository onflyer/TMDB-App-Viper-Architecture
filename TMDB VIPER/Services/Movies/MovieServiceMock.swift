//
//  MovieServiceMock.swift
//  TMDB_VIPER
//
//  Created by Aleksandar Milidrag on 21. 12. 2024..
//

import Foundation

struct MovieServiceMock: MovieService {
    
    let movies: [Movie]
    let singleMovie: SingleMovie
    let delay: Double
    let showError: Bool
    
    init(movies: [Movie] = Movie.mocks(),singleMovie: SingleMovie = SingleMovie.mock(), delay: Double = 1, showError: Bool = false) {
        self.movies = movies
        self.singleMovie = singleMovie
        self.delay = delay
        self.showError = showError
    }
    
    func getNowPlayingMovies(page: Int) async throws -> [Movie] {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        return Movie.mocks()
    }
    
    func getUpcomingMovies(page: Int) async throws -> [Movie] {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        return Movie.mocks()
    }
    
    func getTopRatedMovies(page: Int) async throws -> [Movie] {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        return Movie.mocks()
    }
    
    func getPopularMovies(page: Int) async throws -> [Movie] {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        return Movie.mocks()
    }
    
    func getSingleMovie(id: Int) async throws -> SingleMovie {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        return SingleMovie.mock()
    }
    
    private func tryShowError() throws {
        if showError {
            throw URLError(.unknown)
        }
    }
}
