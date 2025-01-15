//
//  LocalMoviePersistence.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 12. 1. 2025..
//

import Foundation

protocol FavoriteMoviesService {
    func getFavorites() throws -> [SingleMovie]
    func isFavorite(movie: SingleMovie) throws -> Bool
    func addToFavorites(movie: SingleMovie) throws
    func removeFavorite(movie: SingleMovie) throws
}
