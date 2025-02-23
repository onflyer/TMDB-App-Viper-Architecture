//
//  TheatreLocationsInteractor.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 2. 2025..
//

import Foundation
import MapKit

protocol TheatreLocationsInteractor {
    func getAuthorizationStatus() async -> CLAuthorizationStatus
    func requestLocation() async throws -> CLLocation
    func searchLocations(query: String, region: MKCoordinateRegion) async throws -> [MKMapItem]

}

extension CoreInteractor: TheatreLocationsInteractor {}

