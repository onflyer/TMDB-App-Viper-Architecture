//
//  CoreBuilder.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import SwiftUI

@MainActor
struct CoreBuilder {
    let interactor: CoreInteractor
    
    func homeView(delegate: HomeDelegate = HomeDelegate()) -> some View {
        RouterView { router in
            HomeView(
                presenter: HomePresenter(
                    interactor: interactor,
                    router: CoreRouter(router: router,builder: self)
                ),
                delegate: delegate
            )
        }
    }
    
    func detailView(router: Router, delegate: DetailViewDelegate = DetailViewDelegate()) -> some View {
        DetailView(
            presenter: DetailPresenter(
                interactor: interactor,
                router: CoreRouter( router: router, builder: self)
            ),
            delegate: delegate
        )
    }
    
    func favoritesView(router: Router) -> some View {
        FavoritesView(
            presenter: FavoritesPresenter(
                interactor: interactor,
                router: CoreRouter(router: router, builder: self)
            )
        )
    }
    
    func theatreLocationsView(router: Router) -> some View {
        TheatreLocationsView(
            presenter: TheatreLocationsPresenter(
                interactor: interactor,
                router: CoreRouter(router: router, builder: self)
            )
        )
    }
    
    func trailerModalView(movie: SingleMovie, onDismiss: @escaping () -> Void) -> some View {
        let delegate = TrailersModalDelegate(movie: movie, onDismiss: onDismiss)
        return trailerModalView(delegate: delegate)
    }
    
    func trailerModalView(delegate: TrailersModalDelegate) -> some View {
        TrailersModalView(delegate: delegate)
    }
    
    func imageModalView(imageString: String, onDismiss: @escaping () -> Void) -> some View {
        let delegate = ImageModalViewDelegate(urlString: imageString, onDismiss: onDismiss)
        return imageModalView(delegate: delegate)
    }
    
    func imageModalView(delegate: ImageModalViewDelegate) -> some View {
        ImageModalView(delegate: delegate)
    }
}
