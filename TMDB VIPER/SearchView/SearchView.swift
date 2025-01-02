//
//  SearchView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 2. 1. 2025..
//

import SwiftUI

struct SearchViewDelegate {
    
}

struct SearchView: View {
    @State var presenter: SearchPresenter
    var delegate: SearchViewDelegate
    
    var body: some View {
        List {
            ForEach(presenter.searchedMovies) { movie in
                SearchCellView(posterUrlString: movie.posterURLString, title: movie.title ?? "No title", releaseDate: movie.releaseDateForrmated ?? "No release date", ratingText: movie.ratingText ?? "No rating")
            }
        }
    }
}

#Preview {
    let container = DevPreview.shared.container()
    container.register(MovieManager.self, service: MovieManager(service: MovieServiceMock(delay: 1)))
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))
    return RouterView { router in
        builder.searchView(router: router)
    }
}
