//
//  LocationManager2.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 2. 2025..
//

import Foundation
import MapKit

@Observable
class LocationManager2 {
    
    let service: LocationService2
    
    init(service: LocationService2) {
        self.service = service
    }
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        service.authorizationStatus
    }
    
    func requestLocation() {
        service.requestLocation()
    }
    
    func requestWhenInUseAuthorization() {
        service.requestWhenInUseAuthorization()
    }
    
    func searchLocations(query: String, region: MKCoordinateRegion) async throws -> [MKMapItem] {
        try await service.searchLocations(query: query, region: region)
    }
    
    
}
