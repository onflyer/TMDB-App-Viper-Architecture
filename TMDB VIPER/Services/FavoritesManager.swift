//
//  FavoritesManager.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 12. 1. 2025..
//

import Foundation

@MainActor
@Observable
class FavoritesManager {
    
    let service: FavoriteMoviesService
    
    init(service: FavoriteMoviesService) {
        self.service = service
    }
    
    func getFavorites() throws -> [SingleMovie] {
        try service.getFavorites()
    }
    
    func isFavorite(movie: SingleMovie) throws -> Bool {
        try service.isFavorite(movie: movie)
    }
    
    func addToFavorites(movie: SingleMovie) throws {
        try service.addToFavorites(movie: movie)
    }
    
    func removeFavorite(movie: SingleMovie) throws {
        try service.removeFavorite(movie: movie)
    }
    
}
