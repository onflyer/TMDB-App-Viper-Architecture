//
//  TheatreLocationService.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 18. 2. 2025..
//

import Foundation
import MapKit

class LocationService: NSObject, CLLocationManagerDelegate {
    
    let service: CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.service.delegate = self
        self.service.desiredAccuracy = kCLLocationAccuracyBest
        self.setupPermissions()
    }
    
    func searchLocations(query: String, region: MKCoordinateRegion) async throws -> MKLocalSearch.Response {
        let request = MKLocalSearch.Request()
        request.region = region
        request.naturalLanguageQuery = query
        let response = MKLocalSearch(request: request)
        let results = try await response.start()
        return results
    }
    
    func getLastKnownUserLocation(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) async throws -> CLLocation? {
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
