//
//  MoviesService.swift
//  TMDB MVVM
//
//  Created by Aleksandar Milidrag on 21. 12. 2024.
//

import Foundation

class MoviesService {
    
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getNowPlayingMovies(page: Int) async throws -> [Movie] {
        let request = MoviesRequest.getNowPlayingMovies(page: page)
        let response: MovieList = try await networkService.makeRequest(with: request)
        guard let unwrappedResponse = response.results else {
            throw NetworkError.badRequest
        }
        return unwrappedResponse
    }
}
