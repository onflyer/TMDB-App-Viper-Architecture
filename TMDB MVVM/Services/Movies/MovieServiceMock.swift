//
//  MovieServiceMock.swift
//  TMDB MVVM
//
//  Created by Aleksandar Milidrag on 21. 12. 2024..
//

import Foundation

struct MovieServiceMock: MovieService {
    
    let avatars: [Movie]
    let delay: Double
    let showError: Bool
    
    init(avatars: [Movie] = Movie.mocks(), delay: Double = 1, showError: Bool = false) {
        self.avatars = avatars
        self.delay = delay
        self.showError = showError
    }
    
    func getNowPlayingMovies(page: Int) async throws -> [Movie] {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        return avatars
    }
    
    private func tryShowError() throws {
        if showError {
            throw URLError(.unknown)
        }
    }
}
