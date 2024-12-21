//
//  CoreInteractor.swift
//  TMDB MVVM
//
//  Created by Aleksandar Milidrag on 21. 12. 2024..
//

import Foundation

struct CoreInteractor {
    let movieManager: MovieManager
    
    init(container: DependencyContainer) {
        self.movieManager = container.resolve(MovieManager.self)!
    }
    
    func getNowPlayingMovies(page: Int) async throws -> [Movie] {
        try await movieManager.getNowPlayingMovies(page: page)
    }
    
    func getSingleMovie(id: Int) async throws -> SingleMovie {
        try await movieManager.getSingleMovie(id: id)
    }
    
    //MARK: EXAMPLE: YOU JUST NEED ONE FUNCTION FROM VIEWMODEL JUST CONFORM TO INTERACTOR IN EXTENSION (LOOK IN
    func logIn() {
        
    }
}
