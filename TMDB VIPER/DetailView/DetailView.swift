//
//  DetailView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 12. 2024..
//

import SwiftUI

struct DetailViewDelegate {
    var movieId: Int = SingleMovie.mock().id
}

struct DetailView: View {
    
    @State var presenter: DetailPresenter
    let delegate: DetailViewDelegate

    var body: some View {
        VStack {
            Text(presenter.movie?.title ?? "No title")
                .navigationTitle(presenter.movie?.title ?? "No title")
        }
        .task {
            await presenter.loadSingleMovie(id: delegate.movieId)
        }
    }
}

#Preview {
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container()))
    RouterView { router in
        builder.detailView(router: router)
    }
}
