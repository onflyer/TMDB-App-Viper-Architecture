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

    /// Mock stream that emits 5 fake locations with a 1-second delay, then finishes.
    func streamLocations() -> AsyncStream<CLLocation> {
        AsyncStream { continuation in
            Task {
                let mockLocations = [
                    CLLocation(latitude: 37.37409110, longitude: -122.03100050),
                    CLLocation(latitude: 37.37500000, longitude: -122.03200000),
                    CLLocation(latitude: 37.37600000, longitude: -122.03300000),
                    CLLocation(latitude: 37.37700000, longitude: -122.03400000),
                    CLLocation(latitude: 37.37800000, longitude: -122.03500000)
                ]

                for location in mockLocations {
                    try? await Task.sleep(for: .seconds(1))
                    continuation.yield(location)
                }

                continuation.finish()
            }
        }
    }

    func stopStreamingLocations() {
        // No-op for mock
    }
}
