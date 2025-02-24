//
//  TheatreLocationsRouter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 2. 2025..
//

import Foundation

@MainActor
protocol TheatreLocationsRouter {
    func dismissScreen() 
}

extension CoreRouter: TheatreLocationsRouter {}
