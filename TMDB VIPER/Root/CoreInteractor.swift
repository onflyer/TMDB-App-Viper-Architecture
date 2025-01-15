//
//  CoreInteractor.swift
//  TMDB_VIPER
//
//  Created by Aleksandar Milidrag on 21. 12. 2024..
//

import Foundation

@MainActor 
struct CoreInteractor {
    let movieManager: MovieManager
    let favoritesManager: FavoritesManager
    
    init(container: DependencyContainer) {
        self.movieManager = container.resolve(MovieManager.self)!
        self.favoritesManager = container.resolve(FavoritesManager.self)!
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
    
    func searchMovies(query: String) async throws -> [Movie] {
        try await movieManager.searchMovies(query: query)
    }
    
    func getFavorites() throws -> [SingleMovie] {
        try favoritesManager.getFavorites()
    }
    
    func addToFavorites(movie: SingleMovie) throws {
        try favoritesManager.addToFavorites(movie: movie)
    }
    
    func isFavorite(movie: SingleMovie) throws -> Bool {
        try favoritesManager.isFavorite(movie: movie)
    }
    
    func removeFavorite(movie: SingleMovie) throws {
        try favoritesManager.removeFavorite(movie: movie)
    }

}
