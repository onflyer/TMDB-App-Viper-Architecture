//
//  FavoritesView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 15. 1. 2025..
//

import SwiftUI

struct FavoritesView: View {
    @State var presenter: FavoritesPresenter
    var body: some View {
        Text("SSS")
        ForEach(presenter.favoriteMovies) { movie in
            Text(movie.title ?? "No title")
            
                
        }
//        .listStyle(.plain)
        .navigationTitle("Favorites")
        .task {
            presenter.loadFavorites()
        }
    }
}

#Preview ("Dev preview") {
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container()))
    RouterView { router in
        builder.favoritesView()
    }
}
