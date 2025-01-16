//
//  DetailInteractor.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 12. 2024..
//

import Foundation

protocol DetailInteractor {
    func getSingleMovie(id: Int) async throws -> SingleMovie
    func addToFavorites(movie: SingleMovie) throws
    func removeFavorite(movie: SingleMovie) throws
    func isFavorite(movie: SingleMovie) throws -> Bool
}

extension CoreInteractor: DetailInteractor {}
