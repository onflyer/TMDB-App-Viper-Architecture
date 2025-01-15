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
       
        VStack {
            ForEach(presenter.favoriteMovies) { movie in
                Text(movie.title ?? "No title")
            }
            
        }
        .onAppear {
            presenter.loadFavorites()
        }
    }
}

#Preview ("Dev preview1") {
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container()))
    RouterView { router in
        builder.favoritesView(router: router)
    }
}
