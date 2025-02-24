//
//  LocationServiceProd3.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 2. 2025..
//

import Foundation
import MapKit

final class LocationServiceProd3: NSObject, CLLocationManagerDelegate, LocationService3 {
    
    private let coreLocation: CLLocationManager
    
    override init() {
        coreLocation = CLLocationManager()
        super.init()
        coreLocation.delegate = self
    }
    
    private var permissionContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    
    func getAuthorizationStatus() async -> CLAuthorizationStatus {
        if coreLocation.authorizationStatus == .authorizedWhenInUse {
            return coreLocation.authorizationStatus
        }
        
        return await withCheckedContinuation { continuation in
            permissionContinuation = continuation
            coreLocation.requestWhenInUseAuthorization()
            
        }
    }
    
    func requestLocation() async throws -> CLLocation {
        
        try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            coreLocation.startUpdatingLocation()
        }
    }
    
    func searchLocations(query: String, region: MKCoordinateRegion) async throws -> [MKMapItem] {
        let request = MKLocalSearch.Request()
        request.region = region
        request.naturalLanguageQuery = query
        let response = MKLocalSearch(request: request)
        let results = try await response.start()
        return results.mapItems
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        permissionContinuation?.resume(returning: manager.authorizationStatus)
        permissionContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coreLocation.stopUpdatingLocation()
        guard let location = locations.last else { return }
        locationContinuation?.resume(returning: location)
        locationContinuation = nil
    }
}

