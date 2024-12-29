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
//        let movie = try? await instance.getSingleMovie(id: 6)
//        print(movie!.title)
//    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            delegate.builder.homeView()
        }
        
    }
}
