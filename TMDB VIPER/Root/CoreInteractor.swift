//
//  CoreInteractor.swift
//  TMDB_VIPER
//
//  Created by Aleksandar Milidrag on 21. 12. 2024..
//

import Foundation

@MainActor
struct CoreInteractor {
    let logManager: LogManager
    let movieManager: MovieManager
    let favoritesManager: FavoritesManager
    
    init(container: DependencyContainer) {
        self.logManager = container.resolve(LogManager.self)!
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


extension CoreInteractor {
    
    //MARK: LOGGING FUNCTIONS
    
    func trackEvent(eventName: String, parameters: [String: Any]? = nil, type: LogType = .analytic) {
        logManager.trackEvent(eventName: eventName, parameters: parameters, type: type)
    }
    
    func trackEvent(event: AnyLoggableEvent) {
        logManager.trackEvent(event: event)
    }

    func trackEvent(event: LoggableEvent) {
        logManager.trackEvent(event: event)
    }
    
    func trackScreenEvent(event: LoggableEvent) {
        logManager.trackEvent(event: event)
    }
}
