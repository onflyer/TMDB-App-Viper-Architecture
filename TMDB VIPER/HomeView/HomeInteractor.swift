//
//  HomeInteractor.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import Foundation

protocol HomeInteractor {
    func getNowPlayingMovies(page: Int) async throws -> [Movie] 

}

extension CoreInteractor: HomeInteractor { }
