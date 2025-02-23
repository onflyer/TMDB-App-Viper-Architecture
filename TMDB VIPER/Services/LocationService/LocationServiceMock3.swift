//
//  LocationServiceMock3.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 2. 2025..
//

import Foundation
import MapKit

struct LocationServiceMock3: LocationService3 {
    
    func getAuthorizationStatus() async -> CLAuthorizationStatus {
        let status: CLAuthorizationStatus = .authorizedWhenInUse
        return status
    }
    
    func requestLocation() async throws -> CLLocation {
        return CLLocation ( latitude: 37.37409110, longitude: -122.03100050)
    }
    
    func searchLocations(query: String, region: MKCoordinateRegion) async throws -> [MKMapItem] {
        return [ MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.37409110, longitude: -122.03100050))),
                 MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.38888760, longitude: -121.98307640)))]
    }
    
    
}
