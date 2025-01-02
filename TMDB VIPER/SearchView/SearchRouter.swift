//
//  SearchRouter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 2. 1. 2025..
//

import Foundation

protocol SearchRouter {
    func showDetailView(delegate: DetailViewDelegate)
}

extension CoreRouter: SearchRouter {}
