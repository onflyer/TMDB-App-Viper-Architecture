//
//  DetailRouter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 12. 2024..
//

import Foundation

protocol DetailRouter {
    func showTrailerModalView(movie: SingleMovie, onXMarkPressed: @escaping () -> Void)
    func showFavoritesView()
    func dismissModal()
    func dismissScreen()
}

extension CoreRouter: DetailRouter {}
