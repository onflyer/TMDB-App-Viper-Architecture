//
//  TheatreLocationService.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 18. 2. 2025..
//

import Foundation
import MapKit

struct MapKitLocationService {
    
    let service: CLLocationManager
    
    init(service: CLLocationManager = CLLocationManager()) {
        self.service = service
        self.setupPermissions()
        service.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func searchLocations(query: String) async throws -> MKLocalSearch.Response {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        let response = MKLocalSearch(request: request)
        let results = try await response.start()
        return results
    }
    
    func getLastKnownUserLocation(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) throws -> CLLocation? {
        service.startUpdatingLocation()
        return locations.last
    }
    
    func setupPermissions() {
        switch service.authorizationStatus {
            //If we are authorized then we request location just once,
            // to center the map
        case .authorizedWhenInUse:
            service.requestLocation()
            //If we don´t, we request authorization
        case .notDetermined:
            service.startUpdatingLocation()
            service.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard .authorizedWhenInUse == manager.authorizationStatus || manager.authorizationStatus == .authorizedAlways else { return }
        service.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error)")
    }
}
