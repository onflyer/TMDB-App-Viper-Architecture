//
//  Dependencies.swift
//  TMDB_VIPER
//
//  Created by Aleksandar Milidrag on 21. 12. 2024.
//

import SwiftUI
import SwiftfulLogging

typealias LogManager = SwiftfulLogging.LogManager
typealias LoggableEvent = SwiftfulLogging.LoggableEvent
typealias LogType = SwiftfulLogging.LogType
typealias LogService = SwiftfulLogging.LogService
typealias AnyLoggableEvent = SwiftfulLogging.AnyLoggableEvent

@MainActor
struct Dependencies {
    let container: DependencyContainer
    let logManager: LogManager
    let movieManager: MovieManager
    let favoritesManager: FavoritesManager
    let locationManager: LocationManager2
    
    init() {
        logManager = LogManager(services: [ConsoleService(printParameters: true)])
        let networkManager = NetworkManager()
        movieManager = MovieManager(service: MovieServiceProd(networkService: networkManager))
        favoritesManager = FavoritesManager(service: SwiftDataFavoriteMoviesServiceProd())
        locationManager = LocationManager2(service: LocationServiceProd2())
        
        
        let container = DependencyContainer()
        container.register(LogManager.self, service: logManager)
        container.register(MovieManager.self, service: movieManager)
        container.register(FavoritesManager.self, service: favoritesManager)
        container.register(LocationManager2.self, service: locationManager)
        self.container = container
    }
}

@MainActor
class DevPreview {
    static let shared = DevPreview()
    
    let logManager: LogManager
    let movieManager: MovieManager
    let favoritesManager: FavoritesManager
    let locationManager: LocationManager2
    
    init() {
        self.logManager = LogManager(services: [])
        self.movieManager = MovieManager(service: MovieServiceMock())
        self.favoritesManager = FavoritesManager(service: SwiftDataFavoriteMoviesServiceMock())
        self.locationManager = LocationManager2(service: LocationServiceMock2())
    }
    
    func container() -> DependencyContainer {
        let container = DependencyContainer()
        container.register(LogManager.self, service: logManager)
        container.register(MovieManager.self, service: movieManager)
        container.register(FavoritesManager.self, service: favoritesManager)
        container.register(LocationManager2.self, service: locationManager)
        return container
    }
}

//extension View {
//    func previewEnvironment() -> some View {
//        self
//            .environment(DevPreview.shared.container())
//    }
//}
