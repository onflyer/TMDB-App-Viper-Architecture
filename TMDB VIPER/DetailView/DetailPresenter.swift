//
//  DetailPresenter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 12. 2024..
//

import SwiftUI

@Observable
class DetailPresenter {
    let interactor: DetailInteractor
    let router: DetailRouter
    
    init(interactor: DetailInteractor, router: DetailRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    
}
