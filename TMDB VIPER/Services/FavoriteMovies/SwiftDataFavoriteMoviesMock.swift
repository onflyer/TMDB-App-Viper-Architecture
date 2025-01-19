//
//  SwiftDataFavoriteMoviesMock.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 12. 1. 2025..
//

import Foundation

@MainActor
struct SwiftDataFavoriteMoviesMock: FavoriteMoviesService {
    
    var movies: [SingleMovie]
    
    init(movies: [SingleMovie] = SingleMovie.mocks()) {
        self.movies = movies
    }
    
    func getFavorites() throws -> [SingleMovie] {
        return SingleMovie.mocks()
    }
    
    func isFavorite(movie: SingleMovie) throws -> Bool {
        movies.first?.id == movie.id
    }
    
    func addToFavorites(movie: SingleMovie) throws {
        
    }
    
    func removeFavorite(movie: SingleMovie) throws {
        
    }
    
    
}
