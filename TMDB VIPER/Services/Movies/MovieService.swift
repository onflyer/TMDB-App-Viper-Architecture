//
//  MovieService.swift
//  TMDB_VIPER
//
//  Created by Aleksandar Milidrag on 21. 12. 2024..
//

import Foundation

protocol MovieService {
    func getNowPlayingMovies(page: Int) async throws -> [Movie]
    func getSingleMovie(id: Int) async throws -> SingleMovie
}
