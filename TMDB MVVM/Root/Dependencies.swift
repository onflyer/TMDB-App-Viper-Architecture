//
//  Dependencies.swift
//  TMDB MVVM
//
//  Created by Aleksandar Milidrag on 21. 12. 2024..
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
    
    let movieManager: MovieManager
    
    init() {
        self.movieManager = MovieManager(service: MovieServiceMock())
    }
    
    var container: DependencyContainer {
        let container = DependencyContainer()
        container.register(MovieManager.self, service: movieManager)
        return container
    }
}

extension View {
    func previewEnvironment() -> some View {
        self
            .environment(DevPreview.shared.container)
    }
}
