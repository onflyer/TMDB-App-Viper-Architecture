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
        HomeView(presenter: HomePresenter(interactor: interactor))
    }
}
