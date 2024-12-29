//
//  DetailView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 12. 2024..
//

import SwiftUI

struct DetailViewDelegate {
    var movieId: Int
}

struct DetailView: View {
    
    @State var presenter: DetailPresenter
    let delegate: DetailViewDelegate

    var body: some View {
        Text(presenter.movie?.title ?? "No title")
            .task {
                await presenter.loadSingleMovie(id: delegate.movieId)
            }
            .navigationTitle(presenter.movie?.title ?? "No title")
    }
}

#Preview {
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container()))
    RouterView { router in
        builder.detailView(router: router, delegate: DetailViewDelegate(movieId: 12345))
    }
}
