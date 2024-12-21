//
//  MovieServiceMock.swift
//  TMDB MVVM
//
//  Created by Aleksandar Milidrag on 21. 12. 2024..
//

import Foundation

struct MovieServiceMock: MovieService {
    
    func getNowPlayingMovies(page: Int) async throws -> [Movie] {
        try? await Task.sleep(for: .seconds(1))
        return Movie.mocks()
    }
}
