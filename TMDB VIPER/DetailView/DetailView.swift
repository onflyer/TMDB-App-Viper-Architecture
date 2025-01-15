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
        VStack(spacing: 0) {
            ZStack {
                ImageLoaderView(urlString: presenter.movie?.backdropURLString ?? "No image")
                    .aspectRatio(16/9, contentMode: .fit)
                    .navigationTitle(presenter.movie?.title ?? "No title")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .overlay(alignment: .bottomTrailing) {
                HStack {
                    Text("Watch trailer")
                        
                    Image(systemName: "play.fill")
                }
                .bold()
                .foregroundStyle(.secondary)
                .tappableBackground()
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .anyButton {
                    presenter.onWatchTrailerPressed()
                }
                .padding()
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
            
            VStack(alignment: .leading) {
                Text(presenter.movie?.title ?? "No title")
                    .bold()
                HStack {
                    ForEach(presenter.movie?.genres ?? [], content: { genre in
                        Text(genre.name ?? "No genre")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    })
                }
            }
            .padding(.leading, 160)
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
        }
        Divider()
        ScrollView {
            VStack(alignment: .leading) {
                Text("Release date")
                    .bold()
                Text(presenter.movie?.releaseDate ?? "No release date")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.bottom)
           
            VStack(alignment: .leading) {
                Text("Overwiew")
                    .bold()
                Text(presenter.movie?.overview ?? "No desctription")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("Favorites")
                    .bold()
                    .foregroundStyle(.blue)
                    .anyButton {
                        presenter.onFavoritesPressed()
                    }
            }
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
