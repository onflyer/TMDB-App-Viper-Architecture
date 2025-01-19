//
//  MovieManager.swift
//  TMDB_VIPER
//
//  Created by Aleksandar Milidrag on 21. 12. 2024..
//

import Foundation

@MainActor
class MovieManager {

    let service: MoviesService
    
    init(service: MoviesService) {
        self.service = service
    }
    
    func getNowPlayingMovies(page: Int) async throws -> [Movie] {
        try await service.getNowPlayingMovies(page: page)
    }
    
    func getUpcomingMovies(page: Int) async throws -> [Movie] {
        try await service.getUpcomingMovies(page: page)

    }
    
    func getTopRatedMovies(page: Int) async throws -> [Movie] {
        try await service.getTopRatedMovies(page: page)

    }
    
    func getPopularMovies(page: Int) async throws -> [Movie] {
        try await service.getTopRatedMovies(page: page)
    }
    
    func getSingleMovie(id: Int) async throws -> SingleMovie {
        try await service.getSingleMovie(id: id)
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        try await service.searchMovies(query: query)
    }
    
}
