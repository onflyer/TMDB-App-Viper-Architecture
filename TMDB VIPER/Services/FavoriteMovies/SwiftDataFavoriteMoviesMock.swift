//
//  SwiftDataFavoriteMoviesMock.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 12. 1. 2025..
//

import Foundation

struct SwiftDataFavoriteMoviesMock: FavoriteMoviesService {
    
    var movies: [Movie]
    
    init(movies: [Movie] = Movie.mocks()) {
        self.movies = movies
    }
    
    func getFavorites() throws -> [Movie] {
        movies
    }
    
    func isFavorite(movie: Movie) throws -> Bool {
        movies.first?.id == movie.id
    }
    
    func addToFavorites(movie: Movie) throws {
        
    }
    
    func removeFavorite(movie: Movie) throws {
        
    }
    
    
}
