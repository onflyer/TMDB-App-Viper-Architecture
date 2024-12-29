//
//  DetailRouter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 12. 2024..
//

import Foundation

protocol DetailRouter {
    func showDetailView(delegate: DetailViewDelegate)
}

extension CoreRouter: DetailRouter {}
