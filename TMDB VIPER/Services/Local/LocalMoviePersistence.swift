//
//  LocalMoviePersistence.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 12. 1. 2025..
//

import Foundation

@MainActor
protocol LocalMoviePersistenceProtocol {
    func getFavorites() throws -> [Movie]
    func isFavorite(movie: Movie) throws -> Bool
    func addToFavorites(movie: Movie) async throws
    func removeFavorite(movie: Movie) throws
}
