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
////        let isFavorite = try? instance.isFavorite(movie: movie!)
////        print(isFavorite?.description)
//    }
    
//    static func main() {
//        let depenenencies = Dependencies()
//        let interactor = CoreInteractor(container: depenenencies.container)
//        
//        let movie = SingleMovie(adult: true, backdropPath: "sss", budget: 2, genres: nil, homepage: nil, id: 321, imdbID: nil, originalLanguage: nil, originalTitle: "TITLEEEEEEEEE 1", overview: "overView", popularity: nil, posterPath: "Poster", releaseDate: nil, revenue: nil, runtime: nil, status: nil, tagline: nil, title: nil, video: nil, voteAverage: nil, voteCount: nil, videos: nil, credits: nil)
//        try? interactor.removeFavorite(movie: movie)
//        
//        let movies = try? interactor.getFavorites()
//        print(movies)
//    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            TheatreLocationsView()
//            delegate.builder.homeView()
        }
        
    }
}
