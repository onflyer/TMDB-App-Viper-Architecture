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
            ZStack {
                ImageLoaderView(urlString: presenter.movie?.backdropURLString ?? "No image")
                    .aspectRatio(16/9, contentMode: .fit)
                    .navigationTitle(presenter.movie?.title ?? "No title")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .zIndex(1)
            .overlay(alignment: .bottomLeading) {
                MovieCellView(title: "", imageName: presenter.movie?.posterURLString ?? "No image")
                    .frame(width: 120, height: 180)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.white, lineWidth: 1)
                    }
                    .offset(x: 20, y: 90)
            }
            ScrollView {
                VStack {
                    Text(presenter.movie?.title ?? "No title")
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .offset(x: 20)
                .padding(.top, 30)
                
            }
            .frame(maxHeight: .infinity)
            .task {
                await presenter.loadSingleMovie(id: delegate.movieId)
            }
        }
    }
}

#Preview {
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container()))
    RouterView { router in
        builder.detailView(router: router)
    }
}
