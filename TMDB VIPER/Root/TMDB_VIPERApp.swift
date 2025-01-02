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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            delegate.builder.homeView()
        }
        
    }
}
