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
    
    init(container: DependencyContainer, movieManager: MovieManager) {
        self.container = container
        self.movieManager = movieManager
        
        let container = DependencyContainer()
        container.register(MovieManager.self, service: MovieManager(service: MovieServiceProd(networkService: NetworkManager())))
    }
}


class DevPreview {
    static let shared = DevPreview()
    
    var container: DependencyContainer {
        let container = DependencyContainer()
        container.register(MovieManager.self, service: movieManager)
        return container
    }
    
    let movieManager: MovieManager
    
    init() {
        self.movieManager = MovieManager(service: MovieServiceMock())
    }
    
   
}

extension View {
    func previewEnvironment() -> some View {
        self
            .environment(DevPreview.shared.container)
    }
}
