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
        Text("Heello")
//        ForEach(presenter.searchedMovies) { movie in
//            SearchCellView(posterUrlString: movie.posterURLString, title: movie.title ?? "No title", releaseDate: movie.releaseDate ?? "No release date", ratingText: movie.ratingText ?? "No rating")
//                .anyButton {
//                    presenter.onMoviePressed(id: movie.id)
//                }
//        }
//        .listStyle(.plain)

    }
}

#Preview ("Dev preview"){
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container()))
    RouterView { router in
        builder.favoritesView(router: router)
    }
}