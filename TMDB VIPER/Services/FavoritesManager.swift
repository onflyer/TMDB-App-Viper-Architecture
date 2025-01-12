//
//  FavoritesManager.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 12. 1. 2025..
//

import Foundation

@MainActor
class FavoritesManager {
    
    let service: FavoriteMoviesService
    
    init(service: FavoriteMoviesService) {
        self.service = service
    }
    
    func getFavorites() throws -> [Movie] {
        try service.getFavorites()
    }
    
    func isFavorite(movie: Movie) throws -> Bool {
        try service.isFavorite(movie: movie)
    }
    
    func addToFavorites(movie: Movie) throws {
        try service.addToFavorites(movie: movie)
    }
    
    func removeFavorite(movie: Movie) throws {
        try service.removeFavorite(movie: movie)
    }
    
}
