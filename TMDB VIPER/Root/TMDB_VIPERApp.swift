//
//  TMDB_VIPERApp.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 21. 12. 2024..
//

import SwiftUI

@main
struct TMDB_VIPERApp: App {
    
//    static func main() async {
//        let instance = MovieManager(service: MovieServiceProd(networkService: NetworkManager()))
//        let movies = try? await instance.searchMovies(query: "lord")
//        print(movies)
//        
//       
//    }
    
//    static func main() {
//        let instance = FavoritesManager(service: SwiftDataFavoriteMoviesServiceProd())
//        let movie = SingleMovie.mocks().first
//        try? instance.addToFavorites(movie: movie!)
//        print("added to favorites")
//        
//        let movies = try? instance.getFavorites()
//        print(movies)
//        let isFavorite = try? instance.isFavorite(movie: movie!)
//        print(isFavorite?.description)
//    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            delegate.builder.homeView()
        }
        
    }
}
