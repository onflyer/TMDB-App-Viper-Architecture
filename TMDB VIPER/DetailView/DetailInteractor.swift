//
//  DetailInteractor.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 12. 2024..
//

import Foundation

protocol DetailInteractor {
    func getSingleMovie(id: Int) async throws -> SingleMovie
}

extension CoreInteractor: DetailInteractor {}
