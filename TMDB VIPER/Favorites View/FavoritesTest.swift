//
//  FavoritesTest.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 15. 1. 2025..
//

import SwiftUI

struct FavoritesTest: View {
    let instance = FavoritesManager(service: SwiftDataFavoriteMoviesServiceProd())
    @State var movies: [SingleMovie] = []
    
    func loadFavorites() throws {
        movies = try instance.getFavorites()
    }
    
    var body: some View {
        VStack {
            ForEach(movies) { movie in
                Text(movie.title ?? "No title")
            }
        }
        .task {
            try? loadFavorites()
        }
            
    }
}

#Preview {
    FavoritesTest()
}
