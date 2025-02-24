//
//  LocationService.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 20. 2. 2025..
//

import MapKit

protocol LocationService3 {
    func getAuthorizationStatus() async -> CLAuthorizationStatus
    func requestLocation() async throws -> CLLocation
    func searchLocations(query: String, region: MKCoordinateRegion) async throws -> [MKMapItem]
}


