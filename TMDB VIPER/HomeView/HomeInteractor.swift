//
//  HomeInteractor.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import Foundation

protocol HomeInteractor {
    func getNowPlayingMovies(page: Int) async throws -> [Movie]
    func getUpcomingMovies(page: Int) async throws -> [Movie]
    func getTopRatedMovies(page: Int) async throws -> [Movie]
    func getPopularMovies(page: Int) async throws -> [Movie]
    func getSingleMovie(id: Int) async throws -> SingleMovie
}

extension CoreInteractor: HomeInteractor { }
