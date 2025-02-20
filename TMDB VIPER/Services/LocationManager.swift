//
//  LocationManager.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 20. 2. 2025..
//

import Observation

@Observable
class LocationManager {
    
    let service: LocationService
    
    init(service: LocationService) {
        self.service = service
    }
}
