//
//  DetailRouter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 12. 2024..
//

import Foundation

@MainActor
protocol DetailRouter {
    func showTrailerModalView(movie: SingleMovie, onXMarkPressed: @escaping () -> Void)
    func showImageModalView(urlString: String, onXMarkPressed: @escaping () -> Void)
    func showFavoritesView()
    func dismissModal()
    func dismissScreen()
}

extension CoreRouter: DetailRouter {}
