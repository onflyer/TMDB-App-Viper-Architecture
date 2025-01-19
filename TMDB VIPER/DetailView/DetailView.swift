//
//  DetailView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 12. 2024..
//

import SwiftUI

struct DetailViewDelegate {
    var movieId: Int = SingleMovie.mock().id
    
    var eventParameters: [String: Any]? {
        nil
    }
}

struct DetailView: View {
    
    @State var presenter: DetailPresenter
    let delegate: DetailViewDelegate
    
    var body: some View {
        
        VStack(spacing: 0) {
            ZStack {
                ImageLoaderView(urlString: presenter.movie?.backdropURLString ?? "No image")
                    .aspectRatio(16/9, contentMode: .fit)
                    .navigationTitle(presenter.movie?.title ?? "Loading...")
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
            
            HStack {
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
                Spacer()
                ZStack {
                    heartImage(Image(systemName: "heart.fill"), isFavorite: presenter.isFavorite)
                        .foregroundStyle(.red)
                    heartImage(Image(systemName: "heart"), isFavorite: !presenter.isFavorite)
                        .foregroundStyle(.primary)
                }
                .frame(width: 30, height: 27)
                .anyButton {
                   presenter.onHeartPressed()
                }
                
            }
            .lineLimit(1)
            .padding(.leading, 160)
            .padding(.trailing, 15)
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
        }
        .redacted(reason: presenter.isLoading ? .placeholder : [])
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
                Text(presenter.movie?.overview ?? "No description")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("Favorites")
                    .font(.footnote)
                    .bold()
                    .foregroundStyle(.blue)
                    .anyButton {
                        presenter.onFavoritesPressed()
                    }
            }
        }
        .redacted(reason: presenter.isLoading ? .placeholder : [])
        .task {
            await presenter.loadSingleMovie(id: delegate.movieId)
        }
        .onAppear {
            presenter.onViewAppear(delegate: delegate)
        }
        .onDisappear {
            presenter.onViewDisappear(delegate: delegate)
        }
    }
}

#Preview {
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container()))
    RouterView { router in
        builder.detailView(router: router)
    }
}


extension DetailView {
    func heartImage(_ image: Image, isFavorite: Bool) -> some View {
        image
            .resizable()
            .scaleEffect(isFavorite ? 1 : 0)
            .opacity(isFavorite ? 1 : 0)
            .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: isFavorite)
    }
}
