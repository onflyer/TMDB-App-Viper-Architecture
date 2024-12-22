//
//  MovieServiceProd.swift
//  TMDB_VIPER
//
//  Created by Aleksandar Milidrag on 21. 12. 2024.
//

import Foundation

struct MovieServiceProd: MovieService {
    
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getNowPlayingMovies(page: Int) async throws -> [Movie] {
        let request = MoviesRequest.getNowPlayingMovies(page: page)
        let response: MovieList = try await networkService.makeRequest(with: request)
        return response.results
    }
    
    func getSingleMovie(id: Int) async throws -> SingleMovie {
        let request = MoviesRequest.getMovieById(movieId: id)
        let response: SingleMovie = try await networkService.makeRequest(with: request)
        return response
    }
}
