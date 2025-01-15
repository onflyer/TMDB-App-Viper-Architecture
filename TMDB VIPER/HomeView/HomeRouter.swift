//
//  HomeRouter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import Foundation

protocol HomeRouter {
    func showDetailView(delegate: DetailViewDelegate)
}

extension CoreRouter: HomeRouter { }
