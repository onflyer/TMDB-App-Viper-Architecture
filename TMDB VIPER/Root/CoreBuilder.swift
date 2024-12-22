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
}
