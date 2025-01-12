//
//  Dependencies.swift
//  TMDB_VIPER
//
//  Created by Aleksandar Milidrag on 21. 12. 2024.
//

import SwiftUI

@MainActor
struct Dependencies {
    let container: DependencyContainer
    let movieManager: MovieManager
    let favoritesManager: FavoritesManager
    
    init() {
        let networkManager = NetworkManager()
        movieManager = MovieManager(service: MovieServiceProd(networkService: networkManager))
        favoritesManager = FavoritesManager(service: SwiftDataFavoriteMoviesServiceProd())
        
        let container = DependencyContainer()
        container.register(MovieManager.self, service: movieManager)
        container.register(FavoritesManager.self, service: favoritesManager)
        self.container = container
    }
}


class DevPreview {
    static let shared = DevPreview()
    
    let movieManager: MovieManager
    
    init() {
        self.movieManager = MovieManager(service: MovieServiceMock())
    }
    
    func container() -> DependencyContainer {
        let container = DependencyContainer()
        container.register(MovieManager.self, service: movieManager)
        return container
    }
}

extension View {
    func previewEnvironment() -> some View {
        self
            .environment(DevPreview.shared.container())
    }
}
