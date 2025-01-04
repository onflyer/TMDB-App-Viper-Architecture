//
//  CoreBuilder.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import SwiftUI

struct CoreBuilder {
    let interactor: CoreInteractor
    
    func homeView() -> some View {
        RouterView { router in
            HomeView(
                presenter: HomePresenter(
                    interactor: interactor,
                    router: CoreRouter(router: router,builder: self)
                )
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
    
    func trailerModalView(movie: SingleMovie, onDismiss: @escaping () -> Void) -> some View {
        let delegate = TrailersModalDelegate(movie: movie) {
            onDismiss()
        }
        return trailerModalView(delegate: delegate)
    }
    
    func trailerModalView(delegate: TrailersModalDelegate) -> some View {
        TrailersModalView(delegate: delegate)
    }
}
