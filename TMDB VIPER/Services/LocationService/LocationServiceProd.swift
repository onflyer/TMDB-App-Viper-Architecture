//
//  TheatreLocationService.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 18. 2. 2025..
//

import MapKit

final class LocationServiceProd: NSObject, LocationService {
    
    private let locationManager = CLLocationManager()
    
    var region = MKCoordinateRegion()
    var userLocation: CLLocation? = nil
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.setup()
    }
    
    func setup() {
        switch locationManager.authorizationStatus {
        //If we are authorized then we request location just once, to center the map
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        //If we don´t, we request authorization
        case .notDetermined:
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func searchLocations(query: String) async throws -> MKLocalSearch.Response {
            let request = MKLocalSearch.Request()
            request.region = region
            request.naturalLanguageQuery = query
            let response = MKLocalSearch(request: request)
            let results = try await response.start()
            return results
    }
    
    func getUserLocation() async throws -> CLLocation? {
        return userLocation
    }
    
    
}

extension LocationServiceProd: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard .authorizedWhenInUse == manager.authorizationStatus || manager.authorizationStatus == .authorizedAlways else { return }
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        userLocation = locations.last
        locations.last.map {
            region = MKCoordinateRegion(
                center: $0.coordinate,
                span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
    }
}




