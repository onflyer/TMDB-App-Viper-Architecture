//
//  SearchInteractor.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 2. 1. 2025..
//

import Foundation

protocol SearchInteractor {
    func searchMovies(query: String) async throws -> [Movie]
}

extension CoreInteractor: SearchInteractor {}
