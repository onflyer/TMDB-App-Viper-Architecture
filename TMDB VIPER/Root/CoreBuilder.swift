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
    
    func searchView(router: Router,delegate: SearchViewDelegate = SearchViewDelegate()) -> some View {
        SearchView(
            presenter: SearchPresenter(
                interactor: interactor,
                router: CoreRouter(router: router,builder: self)
            ),
            delegate: delegate
        )
    }
}
