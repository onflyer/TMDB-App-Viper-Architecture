//
//  LocationManager2.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 2. 2025..
//

import Foundation
import MapKit

@Observable
class LocationManager3 {
    
    let service: LocationService3
    
    init(service: LocationService3) {
        self.service = service
    }
    
    func getAuthorizationStatus() async -> CLAuthorizationStatus {
        await service.getAuthorizationStatus()
    }
    
    func requestLocation() async throws -> CLLocation {
        try await service.requestLocation()
    }
    
    func searchLocations(query: String, region: MKCoordinateRegion) async throws -> [MKMapItem] {
        try await service.searchLocations(query: query, region: region)
    }
}
