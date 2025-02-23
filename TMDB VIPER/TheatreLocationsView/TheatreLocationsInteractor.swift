//
//  TheatreLocationsInteractor.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 2. 2025..
//

import Foundation
import MapKit

protocol TheatreLocationsInteractor {
    func getAuthorizationStatus() -> CLAuthorizationStatus
    func requestLocation()
    func requestWhenInUseAuthorization()
    func searchLocations(query: String, region: MKCoordinateRegion) async throws -> [MKMapItem]
}

extension CoreInteractor: TheatreLocationsInteractor {
}

