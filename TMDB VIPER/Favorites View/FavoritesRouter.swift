//
//  FavoritesRouter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 15. 1. 2025..
//

import Foundation

@MainActor
protocol FavoritesRouter {
    func showDetailView(delegate: DetailViewDelegate)
}

extension CoreRouter: FavoritesRouter {}
