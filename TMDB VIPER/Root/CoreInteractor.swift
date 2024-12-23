//
//  CoreInteractor.swift
//  TMDB_VIPER
//
//  Created by Aleksandar Milidrag on 21. 12. 2024..
//

import Foundation

struct CoreInteractor {
    let movieManager: MovieManager
    
    init(container: DependencyContainer) {
        self.movieManager = container.resolve(MovieManager.self)!
    }
    
    func getNowPlayingMovies(page: Int) async throws -> [Movie] {
        try await movieManager.getNowPlayingMovies(page: page)
    }
    
    func getUpcomingMovies(page: Int) async throws -> [Movie] {
        try await movieManager.getUpcomingMovies(page: page)

    }
    
    func getTopRatedMovies(page: Int) async throws -> [Movie] {
        try await movieManager.getTopRatedMovies(page: page)

    }
    
    func getPopularMovies(page: Int) async throws -> [Movie] {
        try await movieManager.getTopRatedMovies(page: page)
    }
    
    func getSingleMovie(id: Int) async throws -> SingleMovie {
        try await movieManager.getSingleMovie(id: id)
    }
}
