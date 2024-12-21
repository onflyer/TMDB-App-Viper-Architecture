//
//  MovieManager.swift
//  TMDB MVVM
//
//  Created by Aleksandar Milidrag on 21. 12. 2024..
//

import Foundation

class MovieManager: MovieService {
    
    let service: MovieService
    
    init(service: MovieService) {
        self.service = service
    }
    
    func getNowPlayingMovies(page: Int) async throws -> [Movie] {
        try await service.getNowPlayingMovies(page: page)
    }
    
    func getSingleMovie(id: Int) async throws -> SingleMovie {
        try await service.getSingleMovie(id: id)
    }
    
    
}
