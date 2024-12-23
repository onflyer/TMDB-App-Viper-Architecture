//
//  Dependencies.swift
//  TMDB_VIPER
//
//  Created by Aleksandar Milidrag on 21. 12. 2024.
//

import SwiftUI

struct Dependencies {
    let container: DependencyContainer
    let movieManager: MovieManager
    
    init() {
        let networkManager = NetworkManager()
        movieManager = MovieManager(service: MovieServiceProd(networkService: networkManager))
        
        let container = DependencyContainer()
        container.register(MovieManager.self, service: MovieManager(service: MovieServiceProd(networkService: networkManager)))
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
