//
//  MovieServiceProd.swift
//  TMDB_VIPER
//
//  Created by Aleksandar Milidrag on 21. 12. 2024.
//

import Foundation

struct MovieServiceProd: MoviesService {
    
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getNowPlayingMovies(page: Int) async throws -> [Movie] {
        let request = MoviesRequest.getNowPlayingMovies(page: page)
        let response: MovieList = try await networkService.makeRequest(request: request, responseType: MovieList.self)
        return response.results
    }
    
    func getUpcomingMovies(page: Int) async throws -> [Movie] {
        let request = MoviesRequest.getUpcomingMovies(page: page)
        let response: MovieList = try await networkService.makeRequest(request: request, responseType: MovieList.self)
        return response.results
    }
    
    func getTopRatedMovies(page: Int) async throws -> [Movie] {
        let request = MoviesRequest.getTopRatedMovies(page: page)
        let response: MovieList = try await networkService.makeRequest(request: request, responseType: MovieList.self)
        return response.results
    }
    
    func getPopularMovies(page: Int) async throws -> [Movie] {
        let request = MoviesRequest.getPopularMovies(page: page)
        let response: MovieList = try await networkService.makeRequest(request: request, responseType: MovieList.self)
        return response.results
    }
    
    func getSingleMovie(id: Int) async throws -> SingleMovie {
        let request = MoviesRequest.getMovieById(movieId: id)
        let response: SingleMovie = try await networkService.makeRequest(request: request, responseType: SingleMovie.self)
        return response
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        let request = SearchMoviesRequest.searchMovies(query: query)
        let response: MovieList = try await networkService.makeRequest(request: request, responseType: MovieList.self)
        return response.results
    }
}
